
import 'package:diokotest/core/errors/exceptions.dart';
import 'package:diokotest/core/errors/failure.dart';
import 'package:diokotest/core/utils/either.dart';
import 'package:diokotest/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:diokotest/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:diokotest/features/auth/data/models/user_model.dart';
import 'package:diokotest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRemoteDataSource>(), MockSpec<AuthLocalDataSource>()])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  var testUserModel = UserModel(id: 1, name: 'Test', email: 'test@test.com');
  final testUserModelWithToken = UserModelWithToken(user: testUserModel, token: 'token');
  final testUserEntity = testUserModel.toEntity();

  group('login', () {
    test(
        'should return user entity and cache token/user when remote data source is successful',
            () async {
          // Arrange
          when(mockRemoteDataSource.login(email: 'test', password: 'password'))
              .thenAnswer((_) async => testUserModelWithToken);

          // Act
          final result = await repository.login(email: 'test', password: 'password');

          // Assert
          expect(result, isA<Right>());
          verify(mockRemoteDataSource.login(email: 'test', password: 'password'));
          verify(mockLocalDataSource.cacheToken('token'));
          verify(mockLocalDataSource.cacheUser(testUserModelWithToken));
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        });

    test('should return ServerFailure when the remote data source throws a ServerException', () async {
      // Arrange
      when(mockRemoteDataSource.login(email: 'test', password: 'password'))
          .thenThrow(const ServerException('Invalid Credentials'));

      // Act
      final result = await repository.login(email: 'test', password: 'password');

      // Assert
      expect(result.fold((l) => l, (r) => r), isA<ServerFailure>());

    });
  });
}