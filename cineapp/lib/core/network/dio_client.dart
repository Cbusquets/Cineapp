import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'es-UY',
        },
      ),
    );
    return dio;
  }
}