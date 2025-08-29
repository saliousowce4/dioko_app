// lib/main.dart

import 'package:diokotest/shared/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/manager/auth_providers.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }


  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        databaseProvider.overrideWithValue(database),
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