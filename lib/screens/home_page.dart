import 'package:ai_joke_app/models/joke_response.dart';
import 'package:ai_joke_app/services/gemini_service.dart';
import 'package:ai_joke_app/widgets/joke_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _geminiService = GeminiService();

  bool _isLoading = false;
  String? _error;
  JokeResponse? _currentJoke;

  String _selectedCategory = 'Random';

  final List<String> _categories = [
    'Random',
    'Programming',
    'Dad',
    'Knock-knock',
  ];

  Future<void> _generateJoke() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final joke = await _geminiService.generateJoke(
        category: _selectedCategory,
      );
      setState(() {
        _currentJoke = joke;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Joke Generator (Dio)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Category selection
              Row(
                children: [
                  const Text(
                    'Category:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Joke / error / loading
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _error != null
                      ? Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        )
                      : JokeCard(joke: _currentJoke?.joke),
                ),
              ),

              // Generate button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _generateJoke,
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  label: const Text('Generate Joke'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
