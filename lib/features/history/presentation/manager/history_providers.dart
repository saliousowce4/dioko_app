
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/data_sources/history_remote_data_source.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/use_cases/get_payments_usecase.dart';
import 'history_notifier.dart';
import 'history_state.dart';

final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((ref) {
  return HistoryRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(remoteDataSource: ref.watch(historyRemoteDataSourceProvider));
});

// Domain Layer Provider
final getPaymentsUseCaseProvider = Provider<GetPaymentsUseCase>((ref) {
  return GetPaymentsUseCase(ref.watch(historyRepositoryProvider));
});

// Presentation Layer Provider
final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier(getPaymentsUseCase: ref.watch(getPaymentsUseCaseProvider));
});