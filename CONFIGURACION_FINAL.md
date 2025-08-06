# 🔧 Configuración Final - El Búho

## ⚠️ IMPORTANTE: Configurar Credenciales de Supabase

### 📍 Archivo a Modificar: `lib/main.dart`

**ANTES** (líneas 10-13):
```dart
await Supabase.initialize(
  url: 'TU_SUPABASE_URL', // Reemplazar con tu URL de Supabase
  anonKey: 'TU_SUPABASE_ANON_KEY', // Reemplazar con tu clave anónima
);
```

**DESPUÉS** (con tus datos reales):
```dart
await Supabase.initialize(
  url: 'https://xyzabcdef123456.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5emFiY2RlZjEyMzQ1NiIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjkwMjAwMDAwLCJleHAiOjIwMDU3NzYwMDB9.example-key-here',
);
```

## 🗃️ Base de Datos (SQL a Ejecutar en Supabase)

Ve a **SQL Editor** en Supabase y ejecuta **TODO** este código:

### 1. Crear Tablas y Políticas
```sql
-- 1. TABLA DE USUARIOS
CREATE TABLE public.users (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('visitor', 'publisher')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 2. TABLA DE SITIOS TURÍSTICOS
CREATE TABLE public.tourist_sites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address TEXT NOT NULL,
  image_urls TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.tourist_sites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view tourist sites" ON public.tourist_sites
  FOR SELECT USING (true);
CREATE POLICY "Publishers can create sites" ON public.tourist_sites
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND 
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'publisher')
  );
CREATE POLICY "Users can update own sites" ON public.tourist_sites
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own sites" ON public.tourist_sites
  FOR DELETE USING (auth.uid() = user_id);

-- 3. TABLA DE RESEÑAS
CREATE TABLE public.reviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id UUID REFERENCES public.tourist_sites(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  user_name TEXT NOT NULL,
  comment TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  response TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(site_id, user_id)
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view reviews" ON public.reviews FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create reviews" ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own reviews" ON public.reviews FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own reviews" ON public.reviews FOR DELETE USING (auth.uid() = user_id);
CREATE POLICY "Site owners can respond to reviews" ON public.reviews FOR UPDATE USING (
  EXISTS (SELECT 1 FROM public.tourist_sites WHERE id = site_id AND user_id = auth.uid())
);

-- 4. FUNCIÓN AUTOMÁTICA PARA NUEVOS USUARIOS
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, role)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'role');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 5. ÍNDICES PARA RENDIMIENTO
CREATE INDEX idx_tourist_sites_user_id ON public.tourist_sites(user_id);
CREATE INDEX idx_tourist_sites_created_at ON public.tourist_sites(created_at DESC);
CREATE INDEX idx_reviews_site_id ON public.reviews(site_id);
CREATE INDEX idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX idx_reviews_created_at ON public.reviews(created_at DESC);
```

### 2. Storage para Imágenes
```sql
-- POLÍTICAS DE STORAGE
CREATE POLICY "Anyone can view images" ON storage.objects
  FOR SELECT USING (bucket_id = 'tourist-images');

CREATE POLICY "Authenticated users can upload images" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'tourist-images' AND auth.role() = 'authenticated');

CREATE POLICY "Users can delete own images" ON storage.objects
  FOR DELETE USING (bucket_id = 'tourist-images' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## 🪣 Crear Bucket de Storage

1. Ve a **Storage** en Supabase
2. Clic en "Create bucket"
3. **Nombre**: `tourist-images`
4. **Public bucket**: ✅ Habilitado
5. Clic en "Create bucket"

## 🔐 Configurar Authentication

1. Ve a **Authentication** > **Settings**
2. **Email confirmations**: ❌ Deshabilitado
3. **Auth Providers** > **Email**: ✅ Habilitado

## 🚀 Compilar la App

```bash
cd "C:\Users\PC\Desktop\buho"
flutter clean
flutter pub get
flutter build apk --release
```

## ✅ Verificar que Todo Funcione

1. **Registrarse** como usuario nuevo
2. **Iniciar sesión** 
3. **Publicar sitio** (solo publicadores)
4. **Subir fotos** (máximo 5)
5. **Escribir reseñas**
6. **Responder reseñas** (solo dueños de sitios)

---

### 🎯 Ubicación de tu APK final:
```
build/app/outputs/flutter-apk/app-release.apk
```

¡Listo para usar El Búho con Supabase! 🦉✨
