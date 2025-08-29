
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  /// Executes the use case to fetch dashboard data.
  Future<Either<Failure, DashboardEntity>> call() async {
    return await repository.getDashboardData();
  }
}