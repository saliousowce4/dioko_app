import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required String description,
    required double amount,
    required String category,
    required PlatformFile attachment,
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
    required PlatformFile attachment,
  }) async {
    try {
      print('Creating payment - Platform: ${kIsWeb ? "Web" : "Mobile"}');
      print('File name: ${attachment.name}');
      print('File size: ${attachment.size}');

      // ADD THIS ERROR HANDLING:
      if (kIsWeb && attachment.bytes == null) {
        print('ERROR: File bytes not available on web');
        throw ServerException('File bytes not available on web. Please try selecting the file again.');
      }

      if (!kIsWeb && attachment.path == null) {
        print('ERROR: File path not available on mobile');
        throw ServerException('File path not available on mobile. Please try selecting the file again.');
      }

      // Use FormData to send multipart/form-data request
      final formData = FormData.fromMap({
        'description': description,
        'amount': amount,
        'category': category,
        // Create a MultipartFile from the File object
        'attachment': kIsWeb
        // For web, use fromBytes with the file's bytes
            ? MultipartFile.fromBytes(attachment.bytes!, filename: attachment.name)
        // For mobile, use fromFile with the file's path
            : await MultipartFile.fromFile(attachment.path!, filename: attachment.name),
      });

      print('FormData created successfully');
      print('Making POST request to /payments');

      final response = await dio.post('/payments', data: formData);

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to create payment',
        );
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      if (e.response?.statusCode == 422) {
        // Handle validation errors
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw ServerException(firstError);
      }
      throw ServerException(e.response?.data['message'] ?? 'Network Error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw ServerException('Unexpected error: $e');
    }
  }
}
