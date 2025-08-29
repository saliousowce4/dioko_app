// lib/features/auth/data/data_sources/auth_local_data_source.dart

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../shared/db/app_database.dart';
import '../models/user_model.dart';

const CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);

  Future<String> getToken();

  Future<void> clearToken();

  Future<void> cacheUser(UserModel user);
  Future<UserModel> getUser();
  Future<void> clearUser();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final AppDatabase database;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  @override
  Future<void> cacheToken(String token) {
    try {
      return sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
    } catch (e) {
      throw CacheException('Failed to cache token');
    }
  }

  @override
  Future<String> getToken() {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    if (token != null) {
      return Future.value(token);
    } else {
      throw CacheException('No token found');
    }
  }

  @override
  Future<void> clearToken() {
    try {
      return sharedPreferences.remove(CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheException('Failed to clear token');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return database.userDao.insertUser(user);
  }

  @override
  Future<UserModel> getUser() async {
    final user = await database.userDao.findUser();
    if (user != null) return user;
    throw CacheException('No user found in cache');
  }

  @override
  Future<void> clearUser() {
    return database.userDao.deleteUser();
  }

}
