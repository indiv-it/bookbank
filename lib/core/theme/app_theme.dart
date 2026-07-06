import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color green = Color.fromARGB(255, 0, 187, 6);
  static const Color red = Color.fromARGB(255, 255, 0, 0);
  static const Color card = Colors.white;
  static const Color grey = Colors.grey;
  static final Color border = Colors.grey[300]!;
  static final Color background = Colors.grey[100]!;

  // Group Colors
  static const Color blue = Colors.blue;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;
}

class AppSize {
  static const double xs = 10;
  static const double s = 12;
  static const double m = 14;
  static const double l = 16;
  static const double xl = 20;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.blue,
        secondary: AppColors.orange,
        surface: AppColors.card,
        error: AppColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.black,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        labelSmall: TextStyle(fontSize: AppSize.xs, color: AppColors.black),
        bodySmall: TextStyle(fontSize: AppSize.s, color: AppColors.black),
        bodyMedium: TextStyle(fontSize: AppSize.m, color: AppColors.black),
        bodyLarge: TextStyle(fontSize: AppSize.l, color: AppColors.black),
        titleLarge: TextStyle(
          fontSize: AppSize.xl,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.black, size: 24),
    );
  }
}
