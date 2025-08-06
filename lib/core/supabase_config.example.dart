// IMPORTANTE: Este es un archivo de ejemplo
// Crea una copia como supabase_config.dart con tus credenciales reales

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // 🔒 SUSTITUYE ESTAS CREDENCIALES CON LAS TUYAS
  static const String supabaseUrl = 'https://tu-proyecto.supabase.co';
  static const String supabaseAnonKey = 'tu-anon-key-aqui';
  
  // Cliente de Supabase (inicializado en main.dart)
  static SupabaseClient get client => Supabase.instance.client;
  
  // Configuración adicional
  static const bool debugMode = true;
  static const String storageBucket = 'tourist-images';
  
  // URLs para diferentes entornos
  static const String devUrl = 'http://localhost:3000';
  static const String prodUrl = 'https://tu-dominio.com';
}

// INSTRUCCIONES PARA CONFIGURAR:
// 
// 1. Ve a https://supabase.com/dashboard
// 2. Crea un nuevo proyecto o selecciona el existente
// 3. Ve a Settings → API
// 4. Copia:
//    - Project URL → supabaseUrl
//    - anon/public key → supabaseAnonKey
// 5. Crea el archivo lib/core/supabase_config.dart con tus datos
// 6. Ejecuta el SQL de CREAR_TABLAS_COMPLETO.sql en SQL Editor
// 7. Configura Authentication → Sign In / Providers → Email
// 8. Crea el bucket 'tourist-images' en Storage
