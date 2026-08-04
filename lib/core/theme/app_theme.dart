import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Font Sizes ───────────────────────────────────────────────────────────────

class AppSize {
  static const double xs = 12;
  static const double sm = 14;
  static const double base = 16;
  static const double xl = 20;
  static const double xxl = 24;

  // Aliases สำหรับ backward-compatibility กับ code เดิม
  static const double s = sm;
  static const double m = sm;
  static const double l = base;
}

// ─── Dark Theme Colors ────────────────────────────────────────────────────────

class DarkColors {
  static const Color accent = Color(0xFFACF532);
  static const Color cardBg = Color(0xFF141414);
  static const Color red = Color(0xFFFF0000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundWhite = Color(0xFFDDDDDD);
  static const Color chart = Color(0xFF353535);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF808080);
  static const Color background = Color(0xFF000000);
  static const Color text = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFDDDDDD);
  static const Color border = Color(0x31FFFFFF);
  static const List<Color> chartColors = [
    Color(0xFF375FFF),
    Color(0xFF28FFF4),
    Color(0xFF17C800),
    Color(0xFFFF00A1),
    Color(0xFFFCD34D),
    Color(0xFFFCA5A5),
  ];
}

// ─── Light Theme Colors ───────────────────────────────────────────────────────

class LightColors {
  static const Color accent = Color(0xFF8CDD00);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundWhite = Color(0xFF333333);
  static const Color chart = Color(0xFFDDDDDD);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF808080);
  static const Color background = Color(0xFFF1F1F1);
  static const Color text = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFE5E5E5);
  static const List<Color> chartColors = [
    Color(0xFF375FFF),
    Color(0xFF28FFF4),
    Color(0xFF17C800),
    Color(0xFFFF00A1),
    Color(0xFFFCD34D),
    Color(0xFFFCA5A5),
  ];
}

// ─── Shared / Static Colors (ไม่เปลี่ยนตามธีม) ────────────────────────────────

class AppColors {
  // Functional
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF00BB06);
  static const Color red = Color(0xFFFF0000);
  static const Color amber = Colors.amber;
  static const Color grey = Colors.grey;

  // Group palette
  static const Color blue = Colors.blue;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;

  // Legacy aliases (backward-compatibility)
  static Color get card => LightColors.cardBg;
  static Color get border => LightColors.border;
  static Color get background => LightColors.background;
}

// ─── Theme Provider ───────────────────────────────────────────────────────────

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}

// ─── Flutter ThemeData ────────────────────────────────────────────────────────

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: LightColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        surface: LightColors.cardBg,
        surfaceBright: LightColors.black,
        outline: LightColors.border,
        onSurfaceVariant: Colors.grey[400],
        error: LightColors.red,
        onPrimary: LightColors.white,
        onSecondary: LightColors.white,
        onSurface: LightColors.text,
        onError: LightColors.white,
      ),
      textTheme: const TextTheme(
        labelSmall: TextStyle(fontSize: AppSize.xs, color: LightColors.text),
        bodySmall: TextStyle(fontSize: AppSize.sm, color: LightColors.text),
        bodyMedium: TextStyle(fontSize: AppSize.sm, color: LightColors.text),
        bodyLarge: TextStyle(fontSize: AppSize.base, color: LightColors.text),
        titleLarge: TextStyle(
          fontSize: AppSize.xl,
          fontWeight: FontWeight.bold,
          color: LightColors.text,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: LightColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: LightColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: LightColors.border),
        ),
      ),
      iconTheme: const IconThemeData(color: LightColors.text, size: 24),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: DarkColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        surface: const Color(0xFF202020),
        surfaceBright: const Color(0xFF202020),
        outline: Colors.black,
        onSurfaceVariant: const Color.fromARGB(255, 81, 81, 81),
        error: DarkColors.red,
        onPrimary: DarkColors.white,
        onSecondary: DarkColors.white,
        onSurface: DarkColors.text,
        onError: DarkColors.white,
      ),
      textTheme: const TextTheme(
        labelSmall: TextStyle(fontSize: AppSize.xs, color: DarkColors.text),
        bodySmall: TextStyle(fontSize: AppSize.sm, color: DarkColors.text),
        bodyMedium: TextStyle(fontSize: AppSize.sm, color: DarkColors.text),
        bodyLarge: TextStyle(fontSize: AppSize.base, color: DarkColors.text),
        titleLarge: TextStyle(
          fontSize: AppSize.xl,
          fontWeight: FontWeight.bold,
          color: DarkColors.text,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: DarkColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: DarkColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: DarkColors.border),
        ),
      ),
      iconTheme: const IconThemeData(color: DarkColors.text, size: 24),
    );
  }
}
