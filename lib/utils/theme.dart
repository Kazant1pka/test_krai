import 'package:flutter/material.dart';
import 'package:krainet/utils/colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightAppBar,
        titleTextStyle: TextStyle(color: AppColors.ligthThemeText),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightColorScheme,
        secondary: AppColors.ligthThemeText,
      ),
      textTheme: const TextTheme().apply(
        decorationColor: AppColors.ligthThemeText,
        bodyColor: AppColors.ligthThemeText,
        displayColor: AppColors.ligthThemeText,
      ),
      buttonTheme: const ButtonThemeData(
        focusColor: AppColors.ligthThemeText,
        textTheme: ButtonTextTheme.accent,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkAppBar,
        titleTextStyle: TextStyle(color: AppColors.darkThemeText),
      ),
      colorScheme: const ColorScheme.dark(
        background: AppColors.darkBackground,
        primary: AppColors.darkThemeText,
        secondary: AppColors.darkColorScheme,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: AppColors.darkThemeText,
        displayColor: Colors.pink,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
