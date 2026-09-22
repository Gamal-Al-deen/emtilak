import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.gold,
      surface: AppColors.surface,
    ),
    fontFamily: 'Cairo',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: WidgetStatePropertyAll(AppColors.surface),
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
  );
}
