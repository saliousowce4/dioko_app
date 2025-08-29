
import 'dart:io';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentUseCase {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  /// Executes the use case to create a new payment.
  Future<Either<Failure, PaymentEntity>> call({
    required String description,
    required double amount,
    required String category,
    required File attachment,
  }) async {
    return await repository.createPayment(
      description: description,
      amount: amount,
      category: category,
      attachment: attachment,
    );
  }
}