// lib/main.dart

import 'package:diokotest/shared/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/manager/auth_providers.dart';

Future<void> main() async {
  // 1. Ensure Flutter is ready.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize all async services BEFORE the app runs.
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  // 3. Run the app with the initialized services overridden in the ProviderScope.
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        databaseProvider.overrideWithValue(database), // Override the database provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Dioko Payments',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}