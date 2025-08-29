
import 'package:diokotest/features/dashboard/data/models/recent_payment_model.dart';
import 'package:diokotest/features/dashboard/data/models/regular_payment_model.dart';

import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.availableBalance,
    required super.regularPayments,
    required super.recentPayments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      // The API returns a double/int, which is fine.
      availableBalance: double.tryParse(json['available_balance'].toString()) ?? 0.0,
      regularPayments: (json['regular_payments'] as List)
          .map((item) => RegularPaymentModel.fromJson(item))
          .toList(),
      recentPayments: (json['recent_payments'] as List)
          .map((item) => RecentPaymentModel.fromJson(item))
          .toList(),
    );
  }
}