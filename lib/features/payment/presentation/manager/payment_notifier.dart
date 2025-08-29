

import 'dart:io';

import 'package:diokotest/features/payment/presentation/manager/payment_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/manager/dashboard_notifier.dart';
import '../../domain/use_cases/create_payment_usecase.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final CreatePaymentUseCase _createPaymentUseCase;
  final DashboardNotifier _dashboardNotifier;

  PaymentNotifier({
    required CreatePaymentUseCase createPaymentUseCase,
    required DashboardNotifier dashboardNotifier,
  }) : _createPaymentUseCase = createPaymentUseCase,
       _dashboardNotifier = dashboardNotifier,
       super(PaymentInitial());

  Future<void> createPayment({
    required String description,
    required double amount,
    required String category,
    required PlatformFile attachment,
  }) async {
    state = PaymentLoading();
    final result = await _createPaymentUseCase(
      description: description,
      amount: amount,
      category: category,
      attachment: attachment,
    );

    result.fold((failure) => state = PaymentError(failure.message), (payment) {
      state = PaymentSuccess(payment);
      // On success, automatically refresh the dashboard data.
      _dashboardNotifier.fetchDashboardData();
    });
  }

  // Method to reset the state, e.g., after the bottom sheet closes.
  void resetState() {
    state = PaymentInitial();
  }
}
