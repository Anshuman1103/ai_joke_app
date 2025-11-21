import 'package:flutter/material.dart';

/// A beautiful, animated card widget that displays jokes
/// Features gradient backgrounds, smooth animations, and modern styling
class JokeCard extends StatefulWidget {
  final String? joke;

  const JokeCard({super.key, this.joke});

  @override
  State<JokeCard> createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller manages the animation lifecycle
    // vsync: this ensures animations are synchronized with the screen refresh rate
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Fade animation: smoothly transitions opacity from 0 to 1
    // Makes the joke appear smoothly instead of instantly
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Scale animation: starts at 0.8 and grows to 1.0
    // Creates a subtle "pop-in" effect when the joke appears
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack, // Bouncy easing for playful feel
      ),
    );

    // Start animation when widget is first built
    if (widget.joke != null && widget.joke!.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(JokeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When a new joke arrives, reset and replay the animation
    // This creates a smooth transition between jokes
    if (widget.joke != null &&
        widget.joke!.isNotEmpty &&
        widget.joke != oldWidget.joke) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Empty state: Show a friendly message when no joke is available
    if (widget.joke == null || widget.joke!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          // Subtle gradient background for the empty state
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade100, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative emoji icon
            Icon(
              Icons.emoji_emotions_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Press "Generate Joke" to get your first AI joke!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // Joke display state: Beautiful animated card with gradient
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                // Vibrant gradient background: purple to blue to pink
                // Creates a modern, eye-catching appearance
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C5CE7), // Rich purple
                    const Color(0xFF00D2FF), // Bright cyan
                    const Color(0xFFFF6B9D), // Vibrant pink
                  ],
                  stops: const [
                    0.0,
                    0.5,
                    1.0,
                  ], // Color stops for smooth transition
                ),
                borderRadius: BorderRadius.circular(24),
                // Soft shadow for depth and elevation
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decorative emoji icon at the top
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // The actual joke text
                  Text(
                    widget.joke!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
