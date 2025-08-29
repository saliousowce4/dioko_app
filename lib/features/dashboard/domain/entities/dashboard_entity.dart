
import 'package:diokotest/features/dashboard/domain/entities/recent_payment_entity.dart';
import 'package:diokotest/features/dashboard/domain/entities/regular_payment_entity.dart';

class DashboardEntity {
  final double availableBalance;
  final List<RegularPaymentEntity> regularPayments;
  final List<RecentPaymentEntity> recentPayments;

  const DashboardEntity({
    required this.availableBalance,
    required this.regularPayments,
    required this.recentPayments,
  });
}