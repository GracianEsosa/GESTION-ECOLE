import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B5EFC),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF3F6FD),
      primaryColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) =>
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => IconThemeData(color: colorScheme.primary),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.primary.withOpacity(0.12),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primary,
        contentTextStyle: TextStyle(color: colorScheme.onPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: Typography.material2021(platform: TargetPlatform.android).black
          .copyWith(
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorScheme.onBackground,
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onBackground,
            ),
            bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onBackground),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
    );
  }
}
