import 'package:ai_joke_app/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiDioClient {
  final Dio dio;
  final String apiKey;

  GeminiDioClient._(this.dio, this.apiKey);

  factory GeminiDioClient() {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY is missing in .env');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.geminiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    // Logging – very useful while learning
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );

    return GeminiDioClient._(dio, key);
  }
}
