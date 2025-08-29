// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart


import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  // In a real app, you might add a localDataSource here for offline caching.

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardEntity>> getDashboardData() async {
    // Here you could add a check for network connectivity first.
    try {
      final dashboardModel = await remoteDataSource.getDashboardData();
      return Right(dashboardModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}