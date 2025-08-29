
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  // CHANGE THE RETURN TYPE HERE
  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.register(name: name, email: email, password: password);
  }
}