import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String? joke;

  const JokeCard({super.key, this.joke});

  @override
  Widget build(BuildContext context) {
    if (joke == null || joke!.isEmpty) {
      return const Text(
        'Press "Generate Joke" to get your first AI joke!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          joke!,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
