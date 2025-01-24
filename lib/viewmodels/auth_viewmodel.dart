import 'package:blog_app/services/auth_services.dart' as auth;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final auth.AuthService _authService = auth.AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  AuthViewModel() {
    // Listen for auth state changes
    _authService.supabase.auth.onAuthStateChange.listen((AuthState data) {
      _currentUser = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      _startLoading();
      await _authService.signUp(email, password);
      _clearError();
    } on auth.AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Signup failed. Please try again later');
    } finally {
      _stopLoading();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _startLoading();
      await _authService.signIn(email, password);
      _clearError();
    } on auth.AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Invalid credentials. Please try again');
    } finally {
      _stopLoading();
    }
  }

  Future<void> signOut() async {
    try {
      _startLoading();
      await _authService.signOut();
      _clearError();
    } catch (e) {
      _setError('Logout failed. Please try again');
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Initialize auth state when app starts
  void initialize() async {
    _currentUser = _authService.supabase.auth.currentUser;
    notifyListeners();
  }
}
