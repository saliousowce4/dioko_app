// lib/features/auth/presentation/manager/auth_state.dart

import '../../domain/entities/user_entity.dart';

// An abstract class for all auth states.
abstract class AuthState {
  const AuthState();
}

// The initial state when the app starts.
class AuthInitial extends AuthState {
  const AuthInitial();
}

// The state when an auth operation (login/register) is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

// The state when the user is successfully authenticated.
class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
}

// The state when the user is not authenticated or has logged out.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// The state when an error occurs during an auth operation.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}