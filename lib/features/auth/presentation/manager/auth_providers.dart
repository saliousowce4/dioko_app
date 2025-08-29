// lib/features/auth/presentation/manager/auth_providers.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../core/network/dio_client.dart';
import '../../../../shared/db/app_database.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/get_cached_user_usecase.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/logout_usecase.dart';
import '../../domain/use_cases/register_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';


final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

// Data Layer Providers (now all synchronous)
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    database: ref.watch(databaseProvider), // Simple, direct access
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// Domain Layer (Use Cases) Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCachedUserUseCaseProvider = Provider<GetCachedUserUseCase>((ref) {
  return GetCachedUserUseCase(ref.watch(authRepositoryProvider));
});

// Presentation Layer (Notifier) Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCachedUserUseCase: ref.watch(getCachedUserUseCaseProvider),
  );
});