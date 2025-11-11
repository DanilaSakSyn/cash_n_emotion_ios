import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  CupertinoThemeData get currentTheme {
    if (_isDarkMode) {
      return const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.darkPrimary,
        barBackgroundColor: AppColors.darkNavBar,
        scaffoldBackgroundColor: AppColors.darkBackground1,
        textTheme: CupertinoTextThemeData(primaryColor: AppColors.darkText1),
      );
    } else {
      return const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.lightPrimary,
        barBackgroundColor: AppColors.lightNavBar,
        scaffoldBackgroundColor: AppColors.lightBackground1,
        textTheme: CupertinoTextThemeData(primaryColor: AppColors.lightText1),
      );
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    _saveTheme();
    notifyListeners();
  }
}
