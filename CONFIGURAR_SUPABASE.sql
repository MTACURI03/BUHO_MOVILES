-- =============================================
-- CONFIGURACIÓN COMPLETA DE SUPABASE PARA EL BÚHO
-- Copia y pega TODO este código en SQL Editor
-- =============================================

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

-- 7. POLÍTICAS DE STORAGE PARA IMÁGENES
-- (Ejecutar DESPUÉS de crear el bucket 'tourist-images')

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
