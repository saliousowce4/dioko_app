// lib/features/payment/data/models/payment_model.dart

import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.category,
    required super.status,
    required super.attachmentPath,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toString(),
      category: json['category'],
      status: json['status'],
      attachmentPath: json['attachment_path'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}