import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFF0B1F3A);
  static const Color darkSecondary = Color(0xFF123B6D);
  static const Color darkAccent = Color(0xFF4FC3F7);

  // Light Mode Colors
  static const Color lightPrimary = Color(0xFFE0F7FA);
  static const Color lightSecondary = Color(0xFF81D4FA);
  static const Color lightAccent = Color(0xFF0288D1);

  static const Color color1 = Color(0xFF0B1F3A);
  static const Color color2 = Color(0xFF123B6D);
  static const Color color3 = Color(0xFF1E88E5);
  static const Color color4 = Color(0xFF4FC3F7);
  static const Color color5 = Color(0xFFFFFFFF);
  static const Color color6 = Color(0xFFB0C4DE);
  static const Color color7 = Color(0xFFFF8A65);
  static const Color color8 = Color(0xFFFFD54F);

  static LinearGradient mainGradient(bool isDarkMode) {
    return isDarkMode ? darkGradient : lightGradient;
  }

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [Color(0xFF123B6D), Color(0xFF0B1F3A)],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [Color(0xFF81D4FA), Color(0xFFE0F7FA)],
  );

  static Color textColor(bool isDarkMode) {
    return isDarkMode ? Colors.white : const Color(0xFF0B1F3A);
  }

  static Color subTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.white70 : Colors.black54;
  }
  
  static Color cardColor(bool isDarkMode) {
    return isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
  }
}
