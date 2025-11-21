/// Data model representing a joke response from the Gemini API
///
/// This class parses the JSON response from Google's Gemini API
/// and extracts the joke text from the nested structure.
/// The API returns jokes in a specific format: candidates -> content -> parts -> text
class JokeResponse {
  /// The actual joke text content
  final String joke;

  /// Constructor that requires a joke string
  JokeResponse({required this.joke});

  /// Factory constructor that creates a JokeResponse from JSON
  ///
  /// The Gemini API response structure is:
  /// {
  ///   "candidates": [
  ///     {
  ///       "content": {
  ///         "parts": [
  ///           {"text": "The actual joke here"}
  ///         ]
  ///       }
  ///     }
  ///   ]
  /// }
  ///
  /// This method safely navigates through this nested structure,
  /// handling cases where any part might be missing or null.
  factory JokeResponse.fromJson(Map<String, dynamic> json) {
    // Extract the candidates array from the response
    // Candidates contain the generated content from the AI
    final candidates = json['candidates'] as List<dynamic>?;

    // Safety check: if no candidates exist, return a default message
    if (candidates == null || candidates.isEmpty) {
      return JokeResponse(joke: 'No joke returned.');
    }

    // Get the first candidate (usually there's only one)
    // Safely cast to Map to access its properties
    final firstCandidate = candidates[0] as Map<String, dynamic>?;

    // Extract the content object from the candidate
    final content = firstCandidate?['content'] as Map<String, dynamic>?;

    // Extract the parts array from content
    // Parts contain the actual text segments
    final parts = content?['parts'] as List<dynamic>?;

    // Safety check: if no parts exist, return a default message
    if (parts == null || parts.isEmpty) {
      return JokeResponse(joke: 'No joke returned.');
    }

    // Get the first part which contains the text
    final firstPart = parts[0] as Map<String, dynamic>?;

    // Extract the text field, with a fallback if it's null
    final text = firstPart?['text'] as String? ?? 'No joke returned.';

    // Return the joke, trimming any leading/trailing whitespace
    return JokeResponse(joke: text.trim());
  }
}
