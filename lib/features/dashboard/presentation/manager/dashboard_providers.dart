// lib/features/dashboard/presentation/manager/dashboard_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/manager/auth_providers.dart';
import '../../data/data_sources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/use_cases/get_dashboard_data_usecase.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';


// Data Layer Providers
final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(remoteDataSource: ref.watch(dashboardRemoteDataSourceProvider));
});

// Domain Layer (Use Case) Provider
final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

// Presentation Layer (Notifier) Provider
final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  // --- START OF FIX ---
  // Read the authNotifier and pass it to the DashboardNotifier
  final authNotifier = ref.read(authNotifierProvider.notifier);
  return DashboardNotifier(
    getDashboardDataUseCase: ref.watch(getDashboardDataUseCaseProvider),
    authNotifier: authNotifier,
  );
  // --- END OF FIX ---
});