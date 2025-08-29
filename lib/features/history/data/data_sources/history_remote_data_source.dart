// lib/features/history/data/data_sources/history_remote_data_source.dart

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../payment/data/models/payment_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<PaymentModel>> getPayments({int? year, int? month});
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PaymentModel>> getPayments({int? year, int? month}) async {
    // Build the query parameters map, only including non-null values.
    final Map<String, dynamic> queryParameters = {};
    if (year != null) {
      queryParameters['year'] = year;
    }
    if (month != null) {
      queryParameters['month'] = month;
    }

    try {
      final response = await dio.get(
        '/payments',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        // The response data is a List of JSON objects.
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PaymentModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch payment history');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized. Please log in again.');
      }
      throw ServerException(e.response?.data['message'] ?? 'Network Error');
    }
  }
}