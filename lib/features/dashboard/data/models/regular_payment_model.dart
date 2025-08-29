

import '../../domain/entities/regular_payment_entity.dart';

class RegularPaymentModel extends RegularPaymentEntity {
  const RegularPaymentModel({
    required super.category,
    required super.lastAmount,
  });

  factory RegularPaymentModel.fromJson(Map<String, dynamic> json) {
    return RegularPaymentModel(
      category: json['category'],
      // API returns a string, so we can use it directly.
      lastAmount: json['last_amount'].toString(),
    );
  }
}