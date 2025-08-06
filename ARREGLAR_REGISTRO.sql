-- =============================================
-- SOLUCIÓN AL ERROR DE REGISTRO DE USUARIOS
-- Ejecutar en SQL Editor de Supabase
-- =============================================

-- 1. ELIMINAR EL TRIGGER Y FUNCIÓN ANTERIOR (si existe)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 2. CREAR FUNCIÓN CORREGIDA PARA MANEJAR NUEVOS USUARIOS
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'name', 'Usuario'), 
    COALESCE(NEW.raw_user_meta_data->>'role', 'visitor')
  );
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Si hay error, registrar en logs pero no fallar el registro
    RAISE LOG 'Error creating user in public.users: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. CREAR EL TRIGGER NUEVAMENTE
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. VERIFICAR QUE LA TABLA USERS EXISTE
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'users';

-- 5. VERIFICAR POLÍTICAS RLS
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE tablename = 'users';
