
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../dashboard/domain/entities/recent_payment_entity.dart';
import '../../../dashboard/presentation/widgets/recent_payments_list.dart';
import '../manager/history_providers.dart';
import '../manager/history_state.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch initial full history when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyNotifierProvider.notifier).fetchPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyNotifierProvider);
    final historyNotifier = ref.read(historyNotifierProvider.notifier);

    // Generate a list of years for the dropdown
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear - index);
    final daysInMonth = (historyState.selectedYear != null && historyState.selectedMonth != null)
        ? DateUtils.getDaysInMonth(historyState.selectedYear!, historyState.selectedMonth!)
        : 31;
    final days = List.generate(daysInMonth, (index) => index + 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // Horizontal space between filters
              runSpacing: 4.0, // Vertical space if a filter wraps to the next line
              children: [
                // YEAR FILTER
                DropdownButton<int>(
                  value: historyState.selectedYear,
                  hint: const Text('Year'),
                  items: years.map((year) => DropdownMenuItem(value: year, child: Text(year.toString()))).toList(),
                  onChanged: (value) => historyNotifier.onYearChanged(value),
                ),

                // MONTH FILTER
                DropdownButton<int>(
                  value: historyState.selectedMonth,
                  hint: const Text('Month'),
                  items: List.generate(12, (index) => index + 1)
                      .map((month) => DropdownMenuItem(value: month, child: Text(month.toString())))
                      .toList(),
                  onChanged: (value) => historyNotifier.onMonthChanged(value),
                ),

                DropdownButton<int>(
                  value: historyState.selectedDay,
                  hint: const Text('Day'),
                  items: days.map((day) => DropdownMenuItem(value: day, child: Text(day.toString()))).toList(),
                  onChanged: (value) => historyNotifier.onDayChanged(value),
                ),
              ],
            ),
          ),

          // Body Section
          Expanded(
            child: _buildBody(historyState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(HistoryState state) {
    if (state.isLoading && state.originalPayments.isEmpty) { // <-- CHANGE
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
    }

    // --- CHANGE HERE: Read from 'filteredPayments' instead of 'payments' ---
    final recentPayments = state.filteredPayments.map((p) => RecentPaymentEntity(
      id: p.id,
      description: p.description,
      amount: p.amount,
      category: p.category,
      status: p.status,
      date: DateFormat('yyyy-MM-dd').format(p.createdAt),
    )).toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(historyNotifierProvider.notifier).fetchPayments(),
      child: Stack(
        children: [
          RecentPaymentsList(payments: recentPayments),
          if (state.isLoading) // This will now only show on initial fetch
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}