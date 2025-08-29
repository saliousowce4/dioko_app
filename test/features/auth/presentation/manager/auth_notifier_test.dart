

import 'package:diokotest/core/errors/failure.dart';
import 'package:diokotest/core/utils/either.dart';
import 'package:diokotest/features/auth/domain/entities/user_entity.dart';
import 'package:diokotest/features/auth/domain/use_cases/get_cached_user_usecase.dart';
import 'package:diokotest/features/auth/domain/use_cases/login_usecase.dart';
import 'package:diokotest/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:diokotest/features/auth/domain/use_cases/register_usecase.dart';
import 'package:diokotest/features/auth/presentation/manager/auth_notifier.dart';
import 'package:diokotest/features/auth/presentation/manager/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<LoginUseCase>(),
  MockSpec<RegisterUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<GetCachedUserUseCase>(),
])
import 'auth_notifier_test.mocks.dart';

void main() {
  late AuthNotifier notifier;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();

    // Arrange for checkAuthStatus to return Unauthenticated by default in all tests
    when(mockGetCachedUserUseCase.call())
        .thenAnswer((_) async => Left(CacheFailure('No session')));

    notifier = AuthNotifier(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCachedUserUseCase: mockGetCachedUserUseCase,
    );
  });

  const testUser = UserEntity(id: 1, name: 'Test', email: 'test@test.com');

  test('state should be Unauthenticated after initialization if no session is found', () async {
    // Act: Wait for the async constructor logic to complete
    await untilCalled(mockGetCachedUserUseCase.call());

    // Assert: The state should now be Unauthenticated
    expect(notifier.state, isA<Unauthenticated>());
  });

  test('should emit [AuthLoading, Authenticated] when login is successful', () async {

    when(mockLoginUseCase.call(email: 'email', password: 'password'))
        .thenAnswer((_) async => const Right(testUser));

    final future = notifier.login('email', 'password');


    expect(notifier.state, isA<AuthLoading>());

    await future;
    expect(notifier.state, isA<Authenticated>());
  });
}