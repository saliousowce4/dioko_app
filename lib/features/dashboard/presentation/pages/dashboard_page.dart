// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/dashboard_action_button.dart';
import '../../../../shared/widgets/responsive_center.dart';
import '../../../auth/presentation/manager/auth_providers.dart';
import '../../../auth/presentation/manager/auth_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardNotifierProvider.notifier).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      // The background color will come from the theme
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dashboardNotifierProvider.notifier).fetchDashboardData(),
          color: AppTheme.primaryColor,
          child: ResponsiveCenter(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildBody(dashboardState),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    if (state is DashboardLoading && state is! DashboardLoaded) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }
    if (state is DashboardError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
    }
    if (state is DashboardLoaded) {
      final data = state.dashboardData;
      final authState = ref.watch(authNotifierProvider);
      final userName = (authState is Authenticated) ? authState.user.name.split(' ')[0] : 'Utilisateur';

      return CustomScrollView( // Use CustomScrollView for better scroll performance with mixed content
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                _buildHeader(userName),
                const SizedBox(height: 24),

                // --- Balance Card ---
                BalanceCard(balance: data.availableBalance),
                const SizedBox(height: 32),

                // --- Action Buttons ---
                _buildActionButtons(),
                const SizedBox(height: 32),

                // --- Recent Payments Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Paiements Récents',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => context.push('/history'),
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // --- Payments List ---
          SliverToBoxAdapter(
            child: RecentPaymentsList(payments: data.recentPayments),
          ),
        ],
      );
    }
    return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue,',
                style: TextStyle(fontSize: 16, color: AppTheme.secondaryTextColor),
              ),
              Text(
                '$name!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textColor),
              ),
            ],
          ),

          // --- START OF FIX ---
          // Replace the Consumer and PopupMenuButton with a simple IconButton.
          // Since the whole _DashboardPageState has access to 'ref', this will work.
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.secondaryTextColor, size: 28),
            tooltip: 'Se déconnecter',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
          // --- END OF FIX ---
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        DashboardActionButton(
          icon: Icons.payment,
          label: 'Payer',
          onPressed: () {
            ref.read(paymentNotifierProvider.notifier).resetState();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (ctx) => const CreatePaymentBottomSheet(),
            );
          },
        ),
        const SizedBox(width: 16),
        DashboardActionButton(
          icon: Icons.history,
          label: 'Historique',
          onPressed: () => context.push('/history'),
        ),
      ],
    );
  }
}