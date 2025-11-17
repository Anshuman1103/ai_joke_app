import 'package:ai_joke_app/constants/api_constants.dart';
import 'package:ai_joke_app/models/joke_response.dart';
import 'package:ai_joke_app/services/gemini_dio_client.dart';
import 'package:dio/dio.dart';

// class OpenAIService {
//   final Dio _dio;

//   OpenAIService() : _dio = OpenAIDioClient().dio;

//   Future<JokeResponse> generateJoke({String? category}) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.chatCompletionsEndpoint,
//         data: {
//           'model': ApiConstants.model,
//           'messages': [
//             {
//               'role': 'system',
//               'content':
//                   'You are a joke generator. Always respond with a single short, clean joke.',
//             },
//             {'role': 'user', 'content': _buildPrompt(category)},
//           ],
//           'max_tokens': 1000,
//           'temperature': 0.9,
//         },
//       );

//       return JokeResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     } catch (e) {
//       throw Exception('Unexpected error: $e');
//     }
//   }

//   String _buildPrompt(String? category) {
//     if (category == null || category.isEmpty || category == 'Random') {
//       return 'Tell me a short, clean general joke. Avoid offensive content.';
//     }
//     return 'Tell me a short, clean $category joke. Avoid offensive content.';
//   }

//   String _handleDioError(DioException e) {
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.sendTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       return 'Connection timeout while contacting OpenAI.';
//     }

//     if (e.response != null) {
//       return 'OpenAI error: ${e.response?.statusCode} → ${e.response?.data}';
//     }

//     return 'Network error: ${e.message}';
//   }
// }

class GeminiService {
  final GeminiDioClient _client;

  GeminiService() : _client = GeminiDioClient();

  Dio get _dio => _client.dio;
  String get _apiKey => _client.apiKey;

  Future<JokeResponse> generateJoke({String? category}) async {
    final prompt = _buildPrompt(category);

    try {
      final response = await _dio.post(
        // /models/{model}:generateContent
        '/models/${ApiConstants.geminiModel}:generateContent',
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        },
      );

      return JokeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _buildPrompt(String? category) {
    if (category == null || category.isEmpty || category == 'Random') {
      return 'Tell me a short,unique, clean, general joke. Avoid offensive content.';
    }

    return 'Tell me a short, clean $category joke. Avoid offensive content.';
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout while contacting Gemini.';
    }

    if (e.response != null) {
      return 'Gemini API error: ${e.response?.statusCode} → ${e.response?.data}';
    }

    return 'Network error: ${e.message}';
  }
}
