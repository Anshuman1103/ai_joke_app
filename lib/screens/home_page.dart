import 'package:ai_joke_app/models/joke_response.dart';
import 'package:ai_joke_app/services/gemini_service.dart';
import 'package:ai_joke_app/widgets/joke_card.dart';
import 'package:flutter/material.dart';

/// Main screen of the application
/// Displays the joke generator interface with category selection and joke display
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Service instance for making API calls to generate jokes
  final _geminiService = GeminiService();

  // State variables to track loading, errors, and current joke
  bool _isLoading = false;
  String? _error;
  JokeResponse? _currentJoke;

  // Currently selected joke category
  String _selectedCategory = 'Random';

  // Available joke categories for user selection
  final List<String> _categories = [
    'Random',
    'Programming',
    'Dad',
    'Knock-knock',
  ];

  /// Generates a new joke based on the selected category
  /// Handles loading states and error management
  Future<void> _generateJoke() async {
    // Set loading state to true and clear any previous errors
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Call the Gemini service to generate a joke
      final joke = await _geminiService.generateJoke(
        category: _selectedCategory,
      );

      // Update state with the new joke
      setState(() {
        _currentJoke = joke;
      });
    } catch (e) {
      // Handle errors gracefully by storing error message
      setState(() {
        _error = e.toString();
      });
    } finally {
      // Always set loading to false when done (success or error)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Custom AppBar with gradient background
      appBar: AppBar(
        title: const Text('AI Joke Generator'),
        centerTitle: true,
        // Gradient background for a modern look
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6C5CE7), // Rich purple
                Color(0xFF00D2FF), // Bright cyan
              ],
            ),
          ),
        ),
      ),

      // Main body with gradient background
      body: Container(
        // Subtle gradient background for the entire screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Category selection section with modern chip design
                _buildCategorySection(theme, colorScheme),

                const SizedBox(height: 24),

                // Main content area: displays joke, loading, or error
                Expanded(child: _buildContentArea(theme, colorScheme)),

                const SizedBox(height: 20),

                // Generate button with gradient and animation
                _buildGenerateButton(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the category selection section using chips
  /// Chips provide a more modern, touch-friendly interface than dropdowns
  Widget _buildCategorySection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Select Category',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),

        // Category chips - horizontal scrollable list
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  // Visual feedback: selected chips have gradient background
                  selected: isSelected,
                  label: Text(
                    category,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D3436),
                    ),
                  ),
                  // Gradient background for selected chip
                  selectedColor: const Color(0xFF6C5CE7),
                  // Subtle background for unselected chips
                  backgroundColor: Colors.grey.shade100,
                  // Border styling
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF6C5CE7)
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  // Padding for better touch targets
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  // Shape: rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Handle category selection
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Builds the main content area that displays jokes, loading, or errors
  Widget _buildContentArea(ThemeData theme, ColorScheme colorScheme) {
    // Loading state: show animated progress indicator
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom animated loading indicator with gradient colors
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Generating your joke...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Error state: display error message in a styled container
    if (_error != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.shade200, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Success state: display the joke card
    return Center(
      child: SingleChildScrollView(child: JokeCard(joke: _currentJoke?.joke)),
    );
  }

  /// Builds the generate button with gradient and icon
  Widget _buildGenerateButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        // Gradient background for the button
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(16),
        // Shadow for depth
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        // Disable button during loading to prevent multiple requests
        onPressed: _isLoading ? null : _generateJoke,
        icon: Icon(
          _isLoading ? Icons.hourglass_empty : Icons.emoji_emotions_outlined,
          size: 24,
        ),
        label: Text(
          _isLoading ? 'Generating...' : 'Generate Joke',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        // Transparent background since container has gradient
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
