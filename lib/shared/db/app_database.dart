// lib/shared/db/app_database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_dao.dart';
import '../../features/auth/data/models/user_model.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [UserModel])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError();
});