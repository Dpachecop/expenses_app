import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _seedColor = Colors.blue;

class AppTheme {
  ThemeData getTheme(bool isDarkMode) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ).textTheme,
      ),
      listTileTheme: const ListTileThemeData(iconColor: _seedColor),
    );
  }
}
