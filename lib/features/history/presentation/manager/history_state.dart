

import '../../../payment/domain/entities/payment_entity.dart';

class HistoryState {
  final bool isLoading;
  final String? error;
  // --- START OF CHANGES ---
  /// The complete list of payments fetched from the API. Never changes after fetch.
  final List<PaymentEntity> originalPayments;
  /// The filtered list of payments to be displayed in the UI.
  final List<PaymentEntity> filteredPayments;
  // --- END OF CHANGES ---
  final int? selectedYear;
  final int? selectedMonth;
  final int? selectedDay;

  const HistoryState({
    this.isLoading = false,
    this.error,
    this.originalPayments = const [], // Initialize as empty
    this.filteredPayments = const [], // Initialize as empty
    this.selectedYear,
    this.selectedMonth,
    this.selectedDay,
  });

  HistoryState copyWith({
    bool? isLoading,
    String? error,
    List<PaymentEntity>? originalPayments,
    List<PaymentEntity>? filteredPayments,
    int? selectedYear,
    int? selectedMonth,
    int? selectedDay,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      originalPayments: originalPayments ?? this.originalPayments,
      filteredPayments: filteredPayments ?? this.filteredPayments,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}