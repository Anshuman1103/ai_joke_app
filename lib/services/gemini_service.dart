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

/// Business Logic Service for Gemini API
///
/// **Purpose**: This class contains the business logic for generating jokes
/// using Google's Gemini AI. It handles the actual API calls, prompt building,
/// and error handling.
///
/// **Why it exists**:
/// - Separates business logic from HTTP client configuration
/// - Provides a clean, simple interface for the UI to use
/// - Handles API-specific details (endpoints, request format, error handling)
/// - Makes it easy to change AI providers without changing UI code
///
/// **What it does**:
/// 1. Uses GeminiDioClient to make HTTP requests (doesn't configure HTTP itself)
/// 2. Builds prompts based on joke category (Random, Programming, Dad, etc.)
/// 3. Makes API calls to Gemini with proper request format
/// 4. Converts API responses into JokeResponse objects
/// 5. Handles and formats errors in a user-friendly way
///
/// **Usage**: This is what your UI (HomePage) uses to generate jokes.
/// You call `generateJoke(category: 'Programming')` and get a joke back.
class GeminiService {
  /// The HTTP client configured for Gemini API
  /// This handles all the low-level HTTP communication
  final GeminiDioClient _client;

  /// Constructor: Creates a new GeminiService instance
  /// Automatically creates a GeminiDioClient for making API calls
  GeminiService() : _client = GeminiDioClient();

  /// Getter: Provides access to the Dio HTTP client
  /// Used internally to make API requests
  Dio get _dio => _client.dio;

  /// Getter: Provides access to the API key
  /// Required for authenticating requests to Gemini API
  String get _apiKey => _client.apiKey;

  /// Generates a joke using Gemini AI
  ///
  /// **Parameters**:
  /// - `category`: Optional category for the joke (e.g., 'Programming', 'Dad')
  ///   If null or 'Random', generates a general joke
  ///
  /// **Returns**: A JokeResponse object containing the generated joke
  ///
  /// **Throws**: Exception if API call fails (network error, API error, etc.)
  ///
  /// **How it works**:
  /// 1. Builds a prompt based on the category
  /// 2. Makes a POST request to Gemini API with the prompt
  /// 3. Parses the response into a JokeResponse object
  /// 4. Returns the joke to the caller
  Future<JokeResponse> generateJoke({String? category}) async {
    // Step 1: Build the prompt based on category
    // This creates the text that will be sent to Gemini AI
    final prompt = _buildPrompt(category);

    try {
      // Step 2: Make API request to Gemini
      // POST request to: /models/gemini-2.5-flash-lite:generateContent
      final response = await _dio.post(
        // Gemini API endpoint format: /models/{model}:generateContent
        // This tells Gemini which model to use and what action to perform
        '/models/${ApiConstants.geminiModel}:generateContent',

        // Query parameters: API key is passed as a query parameter
        // Gemini requires the key in the URL, not headers
        queryParameters: {'key': _apiKey},

        // Request body: The actual data sent to Gemini
        // Gemini expects content in a specific format
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}, // The prompt we built earlier
              ],
            },
          ],
        },
      );

      // Step 3: Parse the response
      // Convert the JSON response into a JokeResponse object
      // This makes it easy to use in the UI
      return JokeResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Step 4: Handle Dio-specific errors (network, timeout, API errors)
      // Convert technical errors into user-friendly messages
      throw Exception(_handleDioError(e));
    } catch (e) {
      // Step 5: Handle any unexpected errors
      // Catches errors that aren't DioException (shouldn't happen, but safety first)
      throw Exception('Unexpected error: $e');
    }
  }

  /// Builds the prompt text sent to Gemini AI
  ///
  /// **Parameters**:
  /// - `category`: The joke category (e.g., 'Programming', 'Dad', 'Random')
  ///
  /// **Returns**: A formatted prompt string that tells Gemini what kind of joke to generate
  ///
  /// **Purpose**: Creates different prompts based on category to get relevant jokes
  String _buildPrompt(String? category) {
    // If no category or 'Random', ask for a general joke
    if (category == null || category.isEmpty || category == 'Random') {
      return 'Tell me a short,unique, clean, general joke. Avoid offensive content.';
    }

    // Otherwise, ask for a joke in the specific category
    return 'Tell me a short, clean $category joke. Avoid offensive content.';
  }

  /// Handles and formats Dio errors into user-friendly messages
  ///
  /// **Parameters**:
  /// - `e`: The DioException that occurred
  ///
  /// **Returns**: A human-readable error message
  ///
  /// **Purpose**: Converts technical HTTP errors into messages users can understand
  String _handleDioError(DioException e) {
    // Check if it's a timeout error (connection too slow)
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout while contacting Gemini.';
    }

    // Check if it's an API error (server returned an error response)
    // e.g., 401 (unauthorized), 429 (rate limit), 500 (server error)
    if (e.response != null) {
      return 'Gemini API error: ${e.response?.statusCode} → ${e.response?.data}';
    }

    // Generic network error (no internet, DNS failure, etc.)
    return 'Network error: ${e.message}';
  }
}
