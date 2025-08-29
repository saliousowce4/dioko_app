// lib/features/dashboard/data/data_sources/dashboard_remote_data_source.dart

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardModel> getDashboardData() async {
    try {
      final response = await dio.get('/dashboard');
      if (response.statusCode == 200) {
        return DashboardModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to load dashboard data');
      }
    } on DioException catch (e) {
      // Handle 401 Unauthorized
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized. Please log in again.');
      }
      throw ServerException(e.response?.data['message'] ?? 'Network Error');
    }
  }
}