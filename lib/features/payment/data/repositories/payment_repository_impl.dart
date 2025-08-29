
import 'package:file_picker/file_picker.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_sources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentEntity>> createPayment({
    required String description,
    required double amount,
    required String category,
    required PlatformFile attachment,
  }) async {
    try {
      final paymentModel = await remoteDataSource.createPayment(
        description: description,
        amount: amount,
        category: category,
        attachment: attachment,
      );
      return Right(paymentModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
