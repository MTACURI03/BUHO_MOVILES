# � Configuración de Supabase para El Búho

Esta guía te ayudará a configurar Supabase para que la aplicación **El Búho** funcione completamente.

## 📋 Pasos de Configuración

### 1. Crear Proyecto en Supabase
1. Ir a [Supabase](https://supabase.com)
2. Clic en "New project"
3. **Nombre**: "El Búho Turismo"
4. **Organización**: Crear nueva o usar existente
5. **Password de Base de Datos**: Crear una contraseña segura (¡guárdala!)
6. **Región**: Elegir la más cercana (South America - São Paulo)
7. Clic en "Create new project" (toma 2-3 minutos)

### 2. Obtener Configuración del Proyecto
1. En el panel de Supabase, ir a **Settings** > **API**
2. Copiar los siguientes datos:
   - **URL**: `https://tu-proyecto.supabase.co`
   - **anon key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6...` (clave pública)
   - **service_role key**: Solo para operaciones admin (¡mantener secreta!)

### 3. Configurar Base de Datos (SQL Editor)
Ve a **SQL Editor** en Supabase y ejecuta este código:

```sql
-- 1. CREAR TABLA DE USUARIOS
CREATE TABLE public.users (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('visitor', 'publisher')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para users
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 2. CREAR TABLA DE SITIOS TURÍSTICOS
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

-- Habilitar RLS
ALTER TABLE public.tourist_sites ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para tourist_sites
CREATE POLICY "Anyone can view tourist sites" ON public.tourist_sites
  FOR SELECT USING (true);

CREATE POLICY "Publishers can create sites" ON public.tourist_sites
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND 
    EXISTS (
      SELECT 1 FROM public.users 
      WHERE id = auth.uid() AND role = 'publisher'
    )
  );

CREATE POLICY "Users can update own sites" ON public.tourist_sites
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own sites" ON public.tourist_sites
  FOR DELETE USING (auth.uid() = user_id);

-- 3. CREAR TABLA DE RESEÑAS
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

-- Habilitar RLS
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para reviews
CREATE POLICY "Anyone can view reviews" ON public.reviews
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create reviews" ON public.reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews" ON public.reviews
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews" ON public.reviews
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Site owners can respond to reviews" ON public.reviews
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.tourist_sites 
      WHERE id = site_id AND user_id = auth.uid()
    )
  );

-- 4. FUNCIÓN PARA CREAR USUARIO AUTOMÁTICAMENTE
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, role)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'role');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. TRIGGER PARA EJECUTAR LA FUNCIÓN
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 6. ÍNDICES PARA OPTIMIZACIÓN
CREATE INDEX idx_tourist_sites_user_id ON public.tourist_sites(user_id);
CREATE INDEX idx_tourist_sites_created_at ON public.tourist_sites(created_at DESC);
CREATE INDEX idx_reviews_site_id ON public.reviews(site_id);
CREATE INDEX idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX idx_reviews_created_at ON public.reviews(created_at DESC);
```

### 4. Configurar Storage para Imágenes

1. Ve a **Storage** en el panel de Supabase
2. Clic en "Create bucket"
3. **Nombre**: `tourist-images`
4. **Public bucket**: ✅ (habilitado)
5. Clic en "Create bucket"

Luego ejecuta este SQL para las políticas de Storage:

```sql
-- Política para ver imágenes (público)
CREATE POLICY "Anyone can view images" ON storage.objects
  FOR SELECT USING (bucket_id = 'tourist-images');

-- Política para subir imágenes (usuarios autenticados)
CREATE POLICY "Authenticated users can upload images" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'tourist-images' AND 
    auth.role() = 'authenticated'
  );

-- Política para eliminar imágenes (solo el propietario)
CREATE POLICY "Users can delete own images" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'tourist-images' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

### 5. Configurar el Código Flutter

Abre `lib/main.dart` y reemplaza las constantes:

```dart
await Supabase.initialize(
  url: 'https://TU_PROYECTO_ID.supabase.co',
  anonKey: 'TU_ANON_KEY_AQUI',
);
```

**⚠️ IMPORTANTE**: Reemplaza con tus datos reales:

#### Ejemplo real:
```dart
await Supabase.initialize(
  url: 'https://xyzabcdef123456.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5emFiY2RlZjEyMzQ1NiIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjkwMjAwMDAwLCJleHAiOjIwMDU3NzYwMDB9.example',
);
```

### 6. Habilitar Autenticación

1. Ve a **Authentication** > **Settings**
2. Habilitar **Email confirmations**: ❌ (deshabilitado para desarrollo)
3. En **Auth Providers** habilitar **Email**

## 🛠️ Compilar después de configurar

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## ✅ Verificación Paso a Paso

### 1. Base de Datos
Ve a **Database** > **Tables** y verifica que existan:
- ✅ `users`
- ✅ `tourist_sites` 
- ✅ `reviews`

### 2. Storage
Ve a **Storage** y verifica:
- ✅ Bucket `tourist-images` creado
- ✅ Bucket es público

### 3. Authentication
- ✅ Email provider habilitado
- ✅ Email confirmations deshabilitado

### 4. Probar la App
Tu app debería poder:
- ✅ Registrar nuevos usuarios
- ✅ Iniciar sesión
- ✅ Publicar sitios turísticos
- ✅ Subir fotografías (máximo 5 por sitio)
- ✅ Escribir reseñas
- ✅ Responder a reseñas (solo publicadores)

## 🔧 Configuración Adicional (Opcional)

### Variables de Entorno (Recomendado)
Crea un archivo `.env` en la raíz del proyecto:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_anon_key_aqui
```

Y úsalo en `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load();
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

## 🚨 Notas de Seguridad

- ⚠️ **Nunca compartas tu service_role key**
- ✅ El anon key puede ser público (ya está protegido por RLS)
- 🔒 Las políticas RLS protegen automáticamente los datos
- 📱 Solo usuarios autenticados pueden crear contenido
- 💾 Las imágenes tienen límite de 5MB

## 🐛 Solución de Problemas

### Error: "Invalid API key"
- Verifica que la URL y anon key sean correctas
- Asegúrate de que el proyecto Supabase esté activo

### Error: "Row Level Security violation"
- Verifica que todas las políticas SQL se ejecutaron
- Confirma que RLS esté habilitado en todas las tablas

### Error: "Storage bucket not found"
- Verifica que el bucket `tourist-images` exista
- Confirma que sea público
- Ejecuta las políticas de Storage

### Error de autenticación
- Verifica que el Email provider esté habilitado
- Confirma que email confirmations esté deshabilitado

¡Supabase está listo para El Búho! 🦉✨

## 📊 Beneficios de Supabase vs Firebase

- 💰 **Más económico**: 500MB storage gratis vs 1GB en Firebase
- 🗃️ **PostgreSQL**: Base de datos relacional completa
- 🔄 **Real-time**: Actualizaciones en tiempo real
- 🛡️ **RLS nativo**: Seguridad a nivel de fila
- 📈 **Escalable**: Infraestructura moderna
