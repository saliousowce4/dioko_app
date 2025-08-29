
class PaymentEntity {
  final int id;
  final String description;
  final String amount;
  final String category;
  final String status;
  final String attachmentPath;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.status,
    required this.attachmentPath,
    required this.createdAt,
  });
}