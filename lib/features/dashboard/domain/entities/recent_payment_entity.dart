

class RecentPaymentEntity {
final int id;
final String description;
final String amount;
final String category;
final String status;
final String date;

const RecentPaymentEntity({
required this.id,
required this.description,
required this.amount,
required this.category,
required this.status,
required this.date,
});
}