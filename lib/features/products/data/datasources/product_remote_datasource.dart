import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_response_model.dart';

class ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSource(this.dioClient);

  Future<ProductResponseModel> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      return ProductResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<ProductResponseModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/products/search',
        queryParameters: {
          'q': query,
          'limit': limit,
          'skip': skip,
        },
      );

      return ProductResponseModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(
      DioException error,
      ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          'Request timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection.',
        );

      case DioExceptionType.badResponse:
        return ServerException(
          'Server error: ${error.response?.statusCode}',
        );

      default:
        return const UnknownException(
          'Something went wrong. Please try again.',
        );
    }
  }
}