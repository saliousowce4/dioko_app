// lib/core/navigation/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/manager/auth_providers.dart';
import '../../features/auth/presentation/manager/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/history/presentation/pages/history_page.dart';


final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    // This tells the router to rebuild whenever the auth state changes.
    refreshListenable: GoRouterRefreshStream(ref.watch(authNotifierProvider.notifier).stream),
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
      GoRoute(path: '/history', builder: (context, state) => const HistoryPage()),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      // This logic now runs automatically on every auth state change.
      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/dashboard';
      return null;
    },
  );
});

// Helper class to connect the router to Riverpod's stream.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}