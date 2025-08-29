import 'package:diokotest/features/payment/presentation/manager/payment_notifier.dart';
import 'package:diokotest/features/payment/presentation/manager/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../dashboard/presentation/manager/dashboard_providers.dart';
import '../../data/data_sources/payment_remote_data_source.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/use_cases/create_payment_usecase.dart';

// Data Layer Providers
final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(remoteDataSource: ref.watch(paymentRemoteDataSourceProvider));
});
// Domain Layer Provider
final createPaymentUseCaseProvider = Provider<CreatePaymentUseCase>((ref) {
  return CreatePaymentUseCase(ref.watch(paymentRepositoryProvider));
});
// Presentation Layer Provider
final paymentNotifierProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(
    createPaymentUseCase: ref.watch(createPaymentUseCaseProvider),
// Pass the dashboard notifier's ref to allow refreshing
    dashboardNotifier: ref.read(dashboardNotifierProvider.notifier),
  );
});