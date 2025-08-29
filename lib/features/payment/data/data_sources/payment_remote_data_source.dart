import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required String description,
    required double amount,
    required String category,
    required File attachment,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaymentModel> createPayment({
    required String description,
    required double amount,
    required String category,
    required File attachment,
  }) async {
    try {
      // Use FormData to send multipart/form-data request
      final formData = FormData.fromMap({
        'description': description,
        'amount': amount,
        'category': category,
        // Create a MultipartFile from the File object
        'attachment': await MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
      });

      final response = await dio.post('/payments', data: formData);

      if (response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to create payment',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Handle validation errors
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw ServerException(firstError);
      }
      throw ServerException(e.response?.data['message'] ?? 'Network Error');
    }
  }
}
