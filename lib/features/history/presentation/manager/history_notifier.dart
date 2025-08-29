// lib/features/history/presentation/manager/history_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../payment/domain/entities/payment_entity.dart';
import '../../domain/use_cases/get_payments_usecase.dart';
import 'history_state.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  final GetPaymentsUseCase _getPaymentsUseCase;

  HistoryNotifier({required GetPaymentsUseCase getPaymentsUseCase})
      : _getPaymentsUseCase = getPaymentsUseCase,
        super(const HistoryState());

  // --- START OF CHANGES ---

  /// This is now a private helper method to perform the filtering logic.
  void _applyFilters() {
    List<PaymentEntity> filtered = List.from(state.originalPayments);

    if (state.selectedYear != null) {
      filtered = filtered.where((p) => p.createdAt.year == state.selectedYear).toList();
    }
    if (state.selectedMonth != null) {
      filtered = filtered.where((p) => p.createdAt.month == state.selectedMonth).toList();
    }
    if (state.selectedDay != null) {
      filtered = filtered.where((p) => p.createdAt.day == state.selectedDay).toList();
    }

    // Update the state with the newly filtered list.
    state = state.copyWith(filteredPayments: filtered);
  }

  /// Fetches the initial, complete list of payments from the API ONCE.
  Future<void> fetchPayments() async {
    state = state.copyWith(isLoading: true, error: null);
    // We call the use case without any filter parameters to get all payments.
    final result = await _getPaymentsUseCase();

    result.fold(
          (failure) => state = state.copyWith(isLoading: false, error: failure.message),
          (payments) {
        // On success, store the master list AND the initial display list.
        state = state.copyWith(
          isLoading: false,
          originalPayments: payments,
          filteredPayments: payments,
        );
      },
    );
  }

  /// Updates the selected year and applies filters locally.
  void onYearChanged(int? year) {
    state = state.copyWith(selectedYear: year, selectedMonth: null, selectedDay: null);
    _applyFilters();
  }

  /// Updates the selected month and applies filters locally.
  void onMonthChanged(int? month) {
    state = state.copyWith(selectedMonth: month, selectedDay: null);
    _applyFilters();
  }

  /// Updates the selected day and applies filters locally.
  void onDayChanged(int? day) {
    state = state.copyWith(selectedDay: day);
    _applyFilters();
  }

// --- END OF CHANGES ---
}