import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  AuthService() {
    // Escuchar cambios de autenticación
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session?.user != null) {
        _loadUserProfile(session!.user.id);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      _currentUser = AppUser.fromMap(response);
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Registrar en Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Crear perfil de usuario en la tabla users
        final user = AppUser(
          id: response.user!.id,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );

        await _supabase.from('users').insert(user.toMap());
        _currentUser = user;
        notifyListeners();
        return null; // Éxito
      }
      return 'Error al crear la cuenta';
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!.id);
        return null; // Éxito
      }
      return 'Error al iniciar sesión';
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProfile({
    required String name,
    required UserRole role,
  }) async {
    try {
      if (_currentUser == null) return 'Usuario no autenticado';

      final updatedData = {
        'name': name,
        'role': role.toString().split('.').last,
      };
      
      await _supabase
          .from('users')
          .update(updatedData)
          .eq('id', _currentUser!.id);

      _currentUser = _currentUser!.copyWith(name: name, role: role);
      notifyListeners();
      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }
}
