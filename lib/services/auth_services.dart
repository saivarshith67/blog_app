import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  AuthResponse? _response;
  AuthResponse? get response => _response;

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  Future<void> signUp(String email, String password) async {
    try {
      if (!_isEmailValid(email)) {
        throw AuthException('Invalid email format');
      }
      if (!_isPasswordValid(password)) {
        throw AuthException(
            'Password must be at least 8 characters with at least one letter and one number');
      }

      _response = await supabase.auth.signUp(email: email, password: password);
      debugPrint(
          "[AuthService.signUp] : User signed up successfully ${response!.user!.id}");
    } catch (e) {
      throw AuthException('Sign-up failed: ${e.toString()}');
    }
  }

  Future<void> signIn(String email, String password) async {
    if (!_isEmailValid(email)) {
      throw AuthException('Invalid email format');
    }
    if (password.isEmpty) {
      throw AuthException('Password cannot be empty');
    }

    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? get currentUser => supabase.auth.currentUser;

  static bool _isEmailValid(String email) => _emailRegExp.hasMatch(email);
  static bool _isPasswordValid(String password) =>
      _passwordRegExp.hasMatch(password);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
