
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    try {
      final userModelWithToken = await remoteDataSource.login(email: email, password: password) as UserModelWithToken;
      await localDataSource.cacheToken(userModelWithToken.token);
      await localDataSource.cacheUser(userModelWithToken);
      // Convert UserModel to UserEntity before returning
      return Right(userModelWithToken.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password}) async {
    try {
      final userModelWithToken = await remoteDataSource.register(name: name, email: email, password: password) as UserModelWithToken;
      await localDataSource.cacheToken(userModelWithToken.token);
      await localDataSource.cacheUser(userModelWithToken);
      // Convert UserModel to UserEntity before returning
      return Right(userModelWithToken.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch(e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUser() async {
    try {
      final userModel = await localDataSource.getUser();
      await localDataSource.getToken();
      // Convert UserModel to UserEntity before returning
      return Right(userModel.toEntity());
    } on CacheException {
      return Left(CacheFailure('No cached session found.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      await remoteDataSource.logout(token: token);
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      return const Right(null);
    } on ServerException {
      try {
        await localDataSource.clearToken();
        await localDataSource.clearUser();
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}