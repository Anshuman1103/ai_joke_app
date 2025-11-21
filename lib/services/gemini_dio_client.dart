import 'package:ai_joke_app/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// HTTP Client Configuration for Gemini API
///
/// **Purpose**: This class sets up and configures the Dio HTTP client
/// specifically for making requests to Google's Gemini API.
///
/// **Why it exists**:
/// - Separates HTTP client configuration from business logic
/// - Ensures consistent API settings (timeouts, headers, base URL)
/// - Handles API key loading and validation
/// - Provides logging for debugging API requests/responses
///
/// **What it does**:
/// 1. Loads the Gemini API key from environment variables (.env file)
/// 2. Creates a Dio instance with Gemini-specific settings:
///    - Base URL: Points to Gemini API endpoint
///    - Timeouts: 15s connection, 20s receive (prevents hanging requests)
///    - Headers: Sets JSON content type
/// 3. Adds logging interceptor to see request/response details in console
/// 4. Returns a configured client ready to use
///
/// **Usage**: This is used by GeminiService to make actual API calls.
/// You don't use this directly - GeminiService uses it internally.
class GeminiDioClient {
  /// The configured Dio HTTP client instance
  /// This is what actually makes the HTTP requests
  final Dio dio;

  /// The Gemini API key loaded from .env file
  /// Required for authenticating API requests
  final String apiKey;

  // Private constructor - prevents direct instantiation
  // Forces use of the factory constructor which handles setup
  GeminiDioClient._(this.dio, this.apiKey);

  /// Factory constructor that creates and configures the Dio client
  ///
  /// This is the only way to create a GeminiDioClient instance.
  /// It ensures proper initialization with all required settings.
  factory GeminiDioClient() {
    // Step 1: Load API key from environment variables
    // The .env file should contain: GEMINI_API_KEY=your_key_here
    final key = dotenv.env['GEMINI_API_KEY'];

    // Step 2: Validate that API key exists
    // Without a key, we can't make API requests
    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY is missing in .env');
    }

    // Step 3: Create Dio instance with Gemini API configuration
    final dio = Dio(
      BaseOptions(
        // Base URL for all Gemini API requests
        // All endpoints will be relative to this URL
        baseUrl: ApiConstants.geminiBaseUrl,

        // Connection timeout: How long to wait when connecting to server
        // If connection takes longer than 15s, request fails
        connectTimeout: const Duration(seconds: 15),

        // Receive timeout: How long to wait for server response
        // If response takes longer than 20s, request fails
        receiveTimeout: const Duration(seconds: 20),

        // Set content type header - tells server we're sending JSON
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    // Step 4: Add logging interceptor for debugging
    // This logs all requests and responses to the console
    // Very useful during development to see what's being sent/received
    dio.interceptors.add(
      LogInterceptor(
        request: true, // Log request details (URL, method, headers)
        requestBody: true, // Log request body (the data we're sending)
        responseBody: true, // Log response body (the data we receive)
        responseHeader: false, // Don't log response headers (too verbose)
      ),
    );

    // Step 5: Return configured client with API key
    return GeminiDioClient._(dio, key);
  }
}
