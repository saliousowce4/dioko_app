// lib/features/history/domain/use_cases/get_payments_usecase.dart


import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../../payment/domain/entities/payment_entity.dart';
import '../repositories/history_repository.dart';

class GetPaymentsUseCase {
  final HistoryRepository repository;

  GetPaymentsUseCase(this.repository);

  /// Executes the use case to fetch the payment history.
  Future<Either<Failure, List<PaymentEntity>>> call({
    int? year,
    int? month,
  }) async {
    return await repository.getPayments(year: year, month: month);
  }
}