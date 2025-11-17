// class JokeResponse {
//   final String joke;

//   JokeResponse({required this.joke});

//   factory JokeResponse.fromJson(Map<String, dynamic> json) {
//     return JokeResponse(joke: json['joke']);
//   }
// }

// class JokeResponse {
//   final String joke;

//   JokeResponse({required this.joke});

//   factory JokeResponse.fromJson(Map<String, dynamic> json) {
//     final candidates = json['candidates'] as List<dynamic>?;
//     if (candidates == null || candidates.isEmpty) {
//       return JokeResponse(joke: 'No joke returned.');
//     }

//     final message = candidates[0]['content']['parts'][0]['text'] as String?;
//     final content = message?.trim() ?? 'No joke returned.';
//     return JokeResponse(joke: content);
//   }
// }

class JokeResponse {
  final String joke;

  JokeResponse({required this.joke});

  factory JokeResponse.fromJson(Map<String, dynamic> json) {
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      return JokeResponse(joke: 'No joke returned.');
    }

    final firstCandidate = candidates[0] as Map<String, dynamic>?;
    final content = firstCandidate?['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      return JokeResponse(joke: 'No joke returned.');
    }

    final firstPart = parts[0] as Map<String, dynamic>?;
    final text = firstPart?['text'] as String? ?? 'No joke returned.';

    return JokeResponse(joke: text.trim());
  }
}
