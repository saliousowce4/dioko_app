// lib/features/dashboard/presentation/widgets/recent_payments_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/recent_payment_entity.dart';

class RecentPaymentsList extends StatelessWidget {
  final List<RecentPaymentEntity> payments;
  const RecentPaymentsList({super.key, required this.payments});


  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'pending':
        return const Icon(Icons.hourglass_top, color: Colors.orange);
      case 'failed':
        return const Icon(Icons.error, color: Colors.red);
      default:
        return const Icon(Icons.receipt_long, color: Colors.grey);
    }
  }
  // --- END OF CHANGE ---

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No payments found.'),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'fr_SN', symbol: 'CFA', decimalDigits: 0);

    return ListView.builder(
      shrinkWrap: true,
      // Use physics that work well inside a ListView/ScrollView
      physics: const BouncingScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            // --- CHANGE HERE: Use the helper method for the leading icon ---
            leading: _getStatusIcon(payment.status),
            title: Text(payment.description),
            subtitle: Text('${payment.category} - ${payment.date}'),
            trailing: Text(
              currencyFormat.format(double.tryParse(payment.amount) ?? 0),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}