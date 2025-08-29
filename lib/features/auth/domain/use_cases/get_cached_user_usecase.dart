
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;
  GetCachedUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCachedUser();
  }
}