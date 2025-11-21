import 'package:ai_joke_app/screens/home_page.dart';
import 'package:ai_joke_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Main entry point of the application
/// This function initializes Flutter bindings and loads environment variables
/// before starting the app. The WidgetsFlutterBinding.ensureInitialized() call
/// is necessary because we're using async operations (await) before runApp().
Future<void> main() async {
  // Ensures Flutter framework is fully initialized before async operations
  // This is required when using await before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Loads environment variables from .env file (contains API keys)
  await dotenv.load(fileName: 'lib/assets/.env');

  // Starts the Flutter application
  runApp(const MyApp());
}

/// Root widget of the application
/// Configures the overall theme and visual appearance of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Joke Generator',

      // Hides the debug banner that appears in the top-right corner during development
      debugShowCheckedModeBanner: false,

      // Custom theme configuration imported from app_theme.dart
      // Using a vibrant purple-to-blue gradient color scheme for a modern, playful look
      // All theme configurations are now centralized in lib/theme/app_theme.dart
      theme: AppTheme.lightTheme,

      // Sets the initial screen when the app launches
      home: const HomePage(),
    );
  }
}
