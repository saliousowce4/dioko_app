import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  /// Creates a new payment with the given details and attachment.
  ///
  /// Returns a [PaymentEntity] on success (Right),
  /// or a [Failure] on error (Left).
  Future<Either<Failure, PaymentEntity>> createPayment({
    required String description,
    required double amount,
    required String category,
    required PlatformFile attachment,
  });
}
