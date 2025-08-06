-- =============================================
-- CREAR TODAS LAS TABLAS NECESARIAS PARA EL BÚHO
-- Ejecutar TODO este código en SQL Editor de Supabase
-- =============================================

-- 1. CREAR TABLA DE USUARIOS
CREATE TABLE IF NOT EXISTS public.users (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('visitor', 'publisher')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. HABILITAR RLS EN USERS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 3. POLÍTICAS DE SEGURIDAD PARA USERS
DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;

CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 4. CREAR TABLA DE SITIOS TURÍSTICOS
CREATE TABLE IF NOT EXISTS public.tourist_sites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL DEFAULT 0.0,
  longitude DOUBLE PRECISION NOT NULL DEFAULT 0.0,
  address TEXT NOT NULL,
  image_urls TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. HABILITAR RLS EN TOURIST_SITES
ALTER TABLE public.tourist_sites ENABLE ROW LEVEL SECURITY;

-- 6. POLÍTICAS PARA TOURIST_SITES
DROP POLICY IF EXISTS "Anyone can view tourist sites" ON public.tourist_sites;
DROP POLICY IF EXISTS "Publishers can create sites" ON public.tourist_sites;
DROP POLICY IF EXISTS "Users can update own sites" ON public.tourist_sites;
DROP POLICY IF EXISTS "Users can delete own sites" ON public.tourist_sites;

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

-- 7. CREAR TABLA DE RESEÑAS
CREATE TABLE IF NOT EXISTS public.reviews (
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

-- 8. HABILITAR RLS EN REVIEWS
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- 9. POLÍTICAS PARA REVIEWS
DROP POLICY IF EXISTS "Anyone can view reviews" ON public.reviews;
DROP POLICY IF EXISTS "Authenticated users can create reviews" ON public.reviews;
DROP POLICY IF EXISTS "Users can update own reviews" ON public.reviews;
DROP POLICY IF EXISTS "Users can delete own reviews" ON public.reviews;
DROP POLICY IF EXISTS "Site owners can respond to reviews" ON public.reviews;

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

-- 10. CREAR ÍNDICES PARA OPTIMIZACIÓN
CREATE INDEX IF NOT EXISTS idx_tourist_sites_user_id ON public.tourist_sites(user_id);
CREATE INDEX IF NOT EXISTS idx_tourist_sites_created_at ON public.tourist_sites(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_site_id ON public.reviews(site_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON public.reviews(created_at DESC);

-- 11. VERIFICAR QUE TODAS LAS TABLAS SE CREARON
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'tourist_sites', 'reviews')
ORDER BY table_name;
