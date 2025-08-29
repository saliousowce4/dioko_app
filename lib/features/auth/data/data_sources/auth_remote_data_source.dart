// lib/features/auth/data/data_sources/auth_remote_data_source.dart

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  // CHANGE THE RETURN TYPE HERE
  Future<UserModel> register({required String name, required String email, required String password});
  Future<void> logout({required String token});
}
// Implementation of the remote data source.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // The API returns both user and token. We extract both.
        final user = UserModel.fromJson(response.data['user']);
        final token = response.data['token'] as String;
        // We'll return a new object containing both for the repository to handle.
        return UserModelWithToken(user: user, token: token);
      } else {
        throw ServerException(response.data['message'] ?? 'Login Failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network Error');
    }
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );
      // --- START OF CHANGES ---
      if (response.statusCode == 201) {
        // The API now returns the user and token upon registration.
        final user = UserModel.fromJson(response.data['user']);
        final token = response.data['token'] as String;
        return UserModelWithToken(user: user, token: token);
      } else {
        throw ServerException(response.data['message'] ?? 'Registration Failed');
      }
      // --- END OF CHANGES ---
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw ServerException(firstError);
      }
      throw ServerException(e.response?.data['message'] ?? 'Network Error');
    }
  }
  @override
  Future<void> logout({required String token}) async {
    try {
      await dio.post(
        '/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      // We can ignore logout errors on the client, as the main goal is to clear the local token.
      // However, we still throw an exception in case we want to handle it.
      throw ServerException(e.response?.data['message'] ?? 'Logout failed on server');
    }
  }
}

// A helper class to pass both user and token from the data source to the repository.
class UserModelWithToken extends UserModel {
  final String token;

  UserModelWithToken({
    required UserModel user,
    required this.token
  }) : super(id: user.id, name: user.name, email: user.email);
}