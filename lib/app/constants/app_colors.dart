import 'package:flutter/cupertino.dart';

class AppColors {
  // Dark Theme Colors
  static const darkPrimary = Color(0xFF9C27B0);
  static const darkSecondary = Color(0xFF7B2CBF);
  static const darkBackground1 = Color(0xFF1A1A2E);
  static const darkBackground2 = Color(0xFF16213E);
  static const darkCard1 = Color(0xFF2A1A4A);
  static const darkCard2 = Color(0xFF3A2A5A);
  static const darkText1 = Color(0xFFE1BEE7);
  static const darkText2 = Color(0xFFCE93D8);
  static const darkNavBar = Color(0xFF4A148C);

  // Light Theme Colors - More Saturated
  static const lightPrimary = Color(0xFF8B5FBF); // More saturated purple
  static const lightSecondary = Color(0xFF6F42C1); // Rich violet
  static const lightBackground1 = Color(0xFFF3E5F5); // Soft lavender background
  static const lightBackground2 = Color(
    0xFFE1BEE7,
  ); // Light purple gradient end
  static const lightCard = Color(0xFFFFFFFF); // Pure white cards
  static const lightCardBg = Color(
    0xFFF8F4FF,
  ); // Very light purple for containers
  static const lightText1 = Color(0xFF4A148C); // Deep purple text
  static const lightText2 = Color(0xFF6A1B9A); // Medium purple secondary text
  static const lightText3 = Color(0xFF8B5FBF); // Lighter purple for labels
  static const lightNavBar = Color(0xFF8B5FBF); // Same as primary

  // Gradient colors for buttons/cards - Light Theme
  static const lightGradient1 = Color(0xFF9C27B0); // Rich purple
  static const lightGradient2 = Color(0xFF7B1FA2); // Deep purple

  // Shadow colors
  static Color lightShadow = const Color(0xFF8B5FBF).withOpacity(0.25);
  static Color darkShadow = const Color(0xFF9C27B0).withOpacity(0.4);

  // Helper method to get gradient colors
  static List<Color> getBackgroundGradient(bool isDark) {
    return isDark
        ? [darkBackground1, darkBackground2]
        : [lightBackground1, lightBackground2];
  }

  static List<Color> getCardGradient(bool isDark) {
    return isDark ? [darkCard1, darkCard2] : [lightCard, lightCardBg];
  }

  static List<Color> getButtonGradient(bool isDark) {
    return isDark
        ? [darkPrimary, darkSecondary]
        : [lightGradient1, lightGradient2];
  }

  static Color getNavBarColor(bool isDark) {
    return isDark ? darkNavBar : lightNavBar;
  }

  static Color getPrimaryTextColor(bool isDark) {
    return isDark ? darkText1 : lightText1;
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? darkText2 : lightText2;
  }

  static Color getTertiaryTextColor(bool isDark) {
    return isDark ? darkText2 : lightText3;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? darkCard1 : lightCard;
  }

  static Color getContainerColor(bool isDark) {
    return isDark ? darkCard2 : lightCardBg;
  }
}
