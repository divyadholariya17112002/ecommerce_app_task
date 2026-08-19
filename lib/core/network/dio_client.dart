

import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout:
      const Duration(seconds: 10),
      receiveTimeout:
      const Duration(seconds: 10),
      sendTimeout:
      const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}