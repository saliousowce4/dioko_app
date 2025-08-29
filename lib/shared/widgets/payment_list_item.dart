// lib/shared/widgets/payment_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';

class PaymentListItem extends StatelessWidget {
  final String title;
  final String subtitle; // category
  final String amount;
  final String date;
  final String status;

  const PaymentListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.status,
  });

  // --- START OF NEW WIDGETS ---
  /// Helper function to build a colored status chip.
  Widget _buildStatusChip(BuildContext context) {
    IconData icon;
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green.shade700;
        text = 'Complété';
        break;
      case 'pending':
        icon = Icons.hourglass_top_rounded;
        color = Colors.orange.shade700;
        text = 'En attente';
        break;
      case 'failed':
        icon = Icons.cancel;
        color = Colors.red.shade700;
        text = 'Échoué';
        break;
      default:
        icon = Icons.receipt_long;
        color = AppTheme.secondaryTextColor;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  // --- END OF NEW WIDGETS ---

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'CFA', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Increased padding for a more spacious look
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              title.isNotEmpty ? title[0].toUpperCase() : '?',
              style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppTheme.textColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // --- MODIFIED SUBTITLE ---
                Row(
                  children: [
                    Text(
                      '$subtitle • $date',
                      style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 14),
                    ),
                    const Spacer(), // Pushes the status chip to the right if there's space
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // --- MOVED STATUS CHIP AND AMOUNT ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(double.tryParse(amount) ?? 0),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textColor),
              ),
              const SizedBox(height: 6),
              _buildStatusChip(context),
            ],
          ),
        ],
      ),
    );
  }
}