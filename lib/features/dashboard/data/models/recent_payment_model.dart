// lib/features/dashboard/data/models/recent_payment_model.dart


import '../../domain/entities/recent_payment_entity.dart';

class RecentPaymentModel extends RecentPaymentEntity {
  const RecentPaymentModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.category,
    required super.status,
    required super.date,
  });

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) {
    return RecentPaymentModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toString(),
      category: json['category'],
      status: json['status'],
      date: json['date'],
    );
  }
}