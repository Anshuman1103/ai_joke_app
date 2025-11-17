import 'package:ai_joke_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //This line ensures that the Flutter framework and the binding to the underlying platform (e.g., Android, iOS) are fully initialized before running the app. It's necessary because the next line involves asynchronous operations (await).
  await dotenv.load(fileName: 'lib/assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Joke Generator',
      debugShowCheckedModeBanner:
          false, //Hides the small "DEBUG" banner in the top-right corner of the screen.
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const HomePage(),
    );
  }
}
