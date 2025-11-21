import 'package:flutter/material.dart';

/// Application theme configuration
///
/// This file contains all the theme-related configurations for the app.
/// Separating theme data makes it easier to maintain, modify, and potentially
/// support multiple themes (light/dark mode) in the future.
class AppTheme {
  // Private constructor to prevent instantiation
  // This is a utility class with only static members
  AppTheme._();

  /// Primary color - Rich purple used for main actions and branding
  static const Color primaryColor = Color(0xFF6C5CE7);

  /// Secondary color - Bright cyan used for accents and highlights
  static const Color secondaryColor = Color(0xFF00D2FF);

  /// Tertiary color - Vibrant pink used for additional accents
  static const Color tertiaryColor = Color(0xFFFF6B9D);

  /// Surface color - Light gray background for cards and elevated surfaces
  static const Color surfaceColor = Color(0xFFF8F9FA);

  /// Background color - White background for the main app
  static const Color backgroundColor = Color(0xFFFFFFFF);

  /// Text color - Dark gray for primary text
  static const Color textPrimaryColor = Color(0xFF2D3436);

  /// Text color - Medium gray for secondary text
  static const Color textSecondaryColor = Color(0xFF636E72);

  /// Main theme data for the application
  ///
  /// This theme uses Material Design 3 with a vibrant purple-to-blue
  /// gradient color scheme for a modern, playful appearance.
  /// All component themes (buttons, cards, inputs, etc.) are configured here.
  static ThemeData get lightTheme {
    return ThemeData(
      // Enables Material Design 3 design system
      useMaterial3: true,

      // Color scheme - vibrant purple gradient palette
      // These colors are used throughout the app for buttons, app bars, and accents
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor, // Rich purple as the base
        brightness: Brightness.light,
        // Primary: Main action color (buttons, selected items)
        primary: primaryColor,
        // Secondary: Accent color for highlights
        secondary: secondaryColor,
        // Tertiary: Additional accent for variety
        tertiary: tertiaryColor,
        // Surface: Background color for cards and elevated surfaces
        surface: surfaceColor,
        // Background: Main app background
        background: backgroundColor,
      ),

      // AppBar theme - gradient-like appearance with elevation
      // The AppBar uses a gradient background (configured in the widget itself)
      appBarTheme: const AppBarTheme(
        centerTitle: true, // Centers the title text
        elevation: 0, // No shadow for a flat, modern look
        backgroundColor: primaryColor, // Purple background
        foregroundColor: Colors.white, // White text and icons
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5, // Slightly spaced letters for readability
        ),
      ),

      // Card theme - rounded corners and subtle shadows for depth
      // Cards are used throughout the app for displaying content
      cardTheme: CardThemeData(
        elevation: 0, // No elevation for a flat design
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        margin: EdgeInsets.zero, // No default margin
      ),

      // Elevated button theme - rounded, vibrant buttons
      // Buttons use the primary color scheme with rounded corners
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0, // No elevation for flat design
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ), // Comfortable padding for touch targets
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600, // Semi-bold for emphasis
            letterSpacing: 0.5, // Slightly spaced letters
          ),
        ),
      ),

      // Input decoration theme - for dropdowns and text fields
      // Provides consistent styling for all input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // Fill background with color
        fillColor: Colors.white, // White background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ), // Light gray border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ), // Light gray when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor, // Purple border when focused
            width: 2, // Thicker border for emphasis
          ),
        ),
      ),

      // Typography - modern, readable font sizes
      // Defines text styles used throughout the app
      textTheme: const TextTheme(
        // Large headline text (e.g., page titles)
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        // Large body text (e.g., main content)
        bodyLarge: TextStyle(
          fontSize: 18,
          color: textPrimaryColor,
          height: 1.6, // Line height for readability
        ),
        // Medium body text (e.g., secondary content)
        bodyMedium: TextStyle(
          fontSize: 16,
          color: textSecondaryColor,
          height: 1.5, // Line height for readability
        ),
      ),
    );
  }

  /// Dark theme (optional - for future dark mode support)
  ///
  /// Currently not implemented, but this structure makes it easy to add
  /// dark mode support in the future.
  static ThemeData get darkTheme {
    // TODO: Implement dark theme when needed
    return lightTheme;
  }
}
