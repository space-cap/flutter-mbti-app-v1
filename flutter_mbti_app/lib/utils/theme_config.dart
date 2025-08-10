import 'package:flutter/material.dart';

class MBTITheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF9C88FF);
  static const Color primaryLight = Color(0xFFE8E3FF);
  static const Color primaryDark = Color(0xFF6C63FF);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFFB2DFDB);
  
  // Accent colors
  static const Color accentPink = Color(0xFFFF6B9D);
  static const Color accentBlue = Color(0xFF4FC3F7);
  static const Color accentGreen = Color(0xFF81C784);
  static const Color accentOrange = Color(0xFFFFB74D);
  
  // Surface colors
  static const Color surfaceLight = Color(0xFFF8F6FF);
  static const Color surfaceMedium = Color(0xFFF0F0F0);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // MBTI type colors
  static const Map<String, Color> mbtiColors = {
    'analyst': Color(0xFF8E24AA),  // Purple - NT types (Analyst)
    'diplomat': Color(0xFF43A047), // Green - NF types (Diplomat)
    'sentinel': Color(0xFF1E88E5),  // Blue - SJ types (Sentinel)
    'explorer': Color(0xFFE53935),  // Red - SP types (Explorer)
  };
  
  static Color getMBTITypeColor(String type) {
    // NT types (Analysts)
    if (['INTJ', 'INTP', 'ENTJ', 'ENTP'].contains(type.toUpperCase())) {
      return mbtiColors['analyst']!;
    }
    // NF types (Diplomats)
    if (['INFJ', 'INFP', 'ENFJ', 'ENFP'].contains(type.toUpperCase())) {
      return mbtiColors['diplomat']!;
    }
    // SJ types (Sentinels)
    if (['ISTJ', 'ISFJ', 'ESTJ', 'ESFJ'].contains(type.toUpperCase())) {
      return mbtiColors['sentinel']!;
    }
    // SP types (Explorers)
    if (['ISTP', 'ISFP', 'ESTP', 'ESFP'].contains(type.toUpperCase())) {
      return mbtiColors['explorer']!;
    }
    return primaryColor;
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryColor,
      primaryContainer: primaryLight,
      secondary: secondaryColor,
      surface: surfaceLight,
    ),
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: primaryColor.withOpacity(0.5)),
        foregroundColor: primaryColor,
      ),
    ),
    
    // Filled Button Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: primaryColor,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      linearTrackColor: primaryLight,
      circularTrackColor: primaryLight,
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
    ),
    
    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      elevation: 8,
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primaryLight,
      primaryContainer: primaryDark,
      secondary: secondaryLight,
      surface: surfaceDark,
    ),
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      color: Colors.grey.shade800,
    ),
    
    // Similar button themes adapted for dark mode...
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.black,
        backgroundColor: primaryLight,
      ),
    ),
  );
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 40.0;
  
  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusCircle = 999.0;
}