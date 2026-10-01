import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Accents
  static const Color primary = Color(0xFF00B894); // Uplifting Emerald Green
  static const Color primaryLight = Color(0xFF55EFC4);
  static const Color primaryDark = Color(0xFF009374);

  static const Color secondary = Color(0xFF0984E3); // Serene Sky Blue
  static const Color accent = Color(0xFF6C5CE7); // Intuitive Purple
  static const Color warning = Color(0xFFF39C12); // Amber for streaks
  static const Color danger = Color(0xFFFF4757); // Coral Red for SOS & triggers
  static const Color success = Color(0xFF2ED573);

  // Backgrounds & Surfaces (Dark Theme Default for modern mindfulness apps)
  static const Color backgroundDark = Color(0xFF0B132B); // Deepest Midnight
  static const Color surfaceDark = Color(0xFF1C2541); // Card Surface
  static const Color surfaceDarkLight = Color(0xFF3A506B); // Elevated Cards / Chips
  static const Color borderDark = Color(0x22FFFFFF);

  // Backgrounds & Surfaces (Light Theme)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightHover = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1C2541), Color(0xFF161E36)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sosGradient = LinearGradient(
    colors: [Color(0xFFFF4757), Color(0xFFFF6B81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
