
// A generic class to handle two possible return types: Left (Failure) or Right (Success).
abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifRight(value);
}