// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/manager/auth_providers.dart';
import '../../../payment/presentation/manager/payment_providers.dart';
import '../../../payment/presentation/widgets/create_payment_bottom_sheet.dart';
import '../manager/dashboard_providers.dart';
import '../manager/dashboard_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_payments_list.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is first built.
    // We use addPostFrameCallback to ensure the context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardNotifierProvider.notifier).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Payment History',
            onPressed: () {
              context.push('/history');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Reset payment state before showing the sheet
          ref.read(paymentNotifierProvider.notifier).resetState();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Important for keyboard handling
            builder: (ctx) => const CreatePaymentBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardNotifierProvider.notifier).fetchDashboardData(),
        child: _buildBody(dashboardState),
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DashboardError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(dashboardNotifierProvider.notifier).fetchDashboardData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is DashboardLoaded) {
      final data = state.dashboardData;
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          BalanceCard(balance: data.availableBalance),
          const SizedBox(height: 24),
          Text(
            'Recent Payments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          RecentPaymentsList(payments: data.recentPayments),
          // You can add the "Regular Payments" section here as well.
        ],
      );
    }
    // Initial state
    return const Center(child: CircularProgressIndicator());
  }
}