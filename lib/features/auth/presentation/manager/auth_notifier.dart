
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_cases/get_cached_user_usecase.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/logout_usecase.dart';
import '../../domain/use_cases/register_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase; // <-- ADD THIS PROPERTY

  // --- UPDATE THE CONSTRUCTOR ---
  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCachedUserUseCase getCachedUserUseCase, // <-- ADD THIS PARAMETER
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCachedUserUseCase = getCachedUserUseCase, // <-- ASSIGN IT
        super(const AuthInitial()) {
    // Call the check status method as soon as the notifier is created.
    checkAuthStatus();
  }
  // -----------------------------

  // --- ADD THIS NEW METHOD ---
  Future<void> checkAuthStatus() async {
    // We don't need to set a loading state here, as it can be jarring on app start.
    // The router's redirect logic will handle showing the correct screen.
    final result = await _getCachedUserUseCase();
    result.fold(
          (failure) => state = const Unauthenticated(), // If no session, go to login
          (user) => state = Authenticated(user),      // If session found, set as logged in
    );
  }
  // --------------------------

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = Authenticated(user),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    final result = await _registerUseCase(name: name, email: email, password: password);
    result.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = Authenticated(user),
    );
  }

  Future<void> logout() async {
    // No need for a loading state on logout, it should be instant.
    final result = await _logoutUseCase();
    result.fold(
          (failure) => state = AuthError(failure.message),
          (_) => state = const Unauthenticated(),
    );
  }
}