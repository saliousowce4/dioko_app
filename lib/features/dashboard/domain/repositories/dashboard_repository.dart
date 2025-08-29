
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {

  Future<Either<Failure, DashboardEntity>> getDashboardData();
}