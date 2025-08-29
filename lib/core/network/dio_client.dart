import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/manager/auth_providers.dart';

// const String baseUrl = 'http://127.0.0.1:8000/api';
// For Android
//const String baseUrl = 'http://10.0.2.2:8000/api';

const String baseUrl = 'https://dioko-backend-a7ti.onrender.com/api';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  );

  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // These paths do not require a token.
    if (options.path == '/login' || options.path == '/register') {
      print('AuthInterceptor: No token needed for ${options.path}');
      return super.onRequest(options, handler);
    }

    try {
      // Read the local data source provider to get the token.
      final localDataSource = _ref.read(authLocalDataSourceProvider);
      final token = await localDataSource.getToken();
      options.headers['Authorization'] = 'Bearer $token';
      print('AuthInterceptor: Token successfully added for ${options.path}');
    } catch (e) {
      // If no token is found, the request will proceed without it,
      // and the API will return a 401 Unauthorized, which we can handle.
    }

    return super.onRequest(options, handler);
  }
}
