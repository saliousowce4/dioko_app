// lib/features/history/data/repositories/history_repository_impl.dart


import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../../payment/domain/entities/payment_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../data_sources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPayments({int? year, int? month}) async {
    try {
      final paymentModels = await remoteDataSource.getPayments(year: year, month: month);
      // Since PaymentModel extends PaymentEntity, a List<PaymentModel> can be
      // returned as a List<PaymentEntity>. This is called covariance.
      return Right(paymentModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}