// lib/features/dashboard/presentation/manager/dashboard_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/manager/auth_notifier.dart';
import '../../domain/use_cases/get_dashboard_data_usecase.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardDataUseCase _getDashboardDataUseCase;
  final AuthNotifier _authNotifier; // Add this

  DashboardNotifier({
    required GetDashboardDataUseCase getDashboardDataUseCase,
    required AuthNotifier authNotifier, // Add this
  })  : _getDashboardDataUseCase = getDashboardDataUseCase,
        _authNotifier = authNotifier, // Add this
        super(DashboardInitial());

  Future<void> fetchDashboardData() async {
    state = DashboardLoading();
    final result = await _getDashboardDataUseCase();
    result.fold(
          (failure) {
        state = DashboardError(failure.message);
        // --- START OF FIX ---
        // If the error is an auth error, log the user out.
        if (failure.message.toLowerCase().contains('unauthorized')) {
          _authNotifier.logout();
        }
        // --- END OF FIX ---
      },
          (data) => state = DashboardLoaded(data),
    );
  }
}