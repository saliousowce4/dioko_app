
import 'package:diokotest/core/utils/either.dart';
import 'package:diokotest/features/auth/domain/entities/user_entity.dart';
import 'package:diokotest/features/auth/domain/repositories/auth_repository.dart';
import 'package:diokotest/features/auth/domain/use_cases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// This generates a mock_auth_repository.mocks.dart file
@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  const testUserEntity = UserEntity(id: 1, name: 'Test', email: 'test@test.com');
  const testEmail = 'test@test.com';
  const testPassword = 'password';

  test('should get user from the repository when login is successful', () async {
    // Arrange: Setup the mock repository to return a successful result.
    when(mockAuthRepository.login(email: testEmail, password: testPassword))
        .thenAnswer((_) async => const Right(testUserEntity));

    // Act: Call the use case.
    final result = await usecase(email: testEmail, password: testPassword);

    // Assert: Check that the result is the user entity we expect.
    expect(result.fold((l) => l, (r) => r), testUserEntity);
    // Verify that the login method on the repository was called exactly once.
    verify(mockAuthRepository.login(email: testEmail, password: testPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}