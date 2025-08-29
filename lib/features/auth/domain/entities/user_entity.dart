
class UserEntity {
  final int id;
  final String name;
  final String email;
  final double? balance;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.balance,
  });
}