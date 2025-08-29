// lib/features/dashboard/presentation/widgets/recent_payments_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/payment_list_item.dart';
import '../../domain/entities/recent_payment_entity.dart';

class RecentPaymentsList extends StatelessWidget {
  final List<RecentPaymentEntity> payments;
  const RecentPaymentsList({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Aucun paiement trouvé.'), // In French
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        // Use the new reusable widget
        return PaymentListItem(
          title: payment.description,
          subtitle: payment.category,
          date: payment.date,
          amount: payment.amount,   status: payment.status,
        );
      },
      // Add a nice divider between items
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppTheme.cardBackgroundColor,
      ),
    );
  }
}