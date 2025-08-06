import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'services/auth_service_supabase.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://ssowfmnzndfycxfoxdmh.supabase.co', // ⚠️ CAMBIAR: https://tuproyecto.supabase.co
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzb3dmbW56bmRmeWN4Zm94ZG1oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NDk4MDMsImV4cCI6MjA3MDAyNTgwM30.nvF3yeosU5ve7kdDs0xn4Gfb4sDhlL5E564pxQHjWZ4', // ⚠️ CAMBIAR: eyJhbGciOiJIUzI1NiIsInR5cCI6...
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'El Búho - Turismo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
