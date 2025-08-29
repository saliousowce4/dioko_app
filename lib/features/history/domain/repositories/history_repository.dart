// lib/features/history/domain/repositories/history_repository.dart


import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../../payment/domain/entities/payment_entity.dart';

abstract class HistoryRepository {
  /// Fetches a list of payments, with optional filters for year and month.
  ///
  /// If no filters are provided, it should fetch all payments.
  /// Returns a list of [PaymentEntity] on success (Right),
  /// or a [Failure] on error (Left).
  Future<Either<Failure, List<PaymentEntity>>> getPayments({
    int? year,
    int? month,
  });
}