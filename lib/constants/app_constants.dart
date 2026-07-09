import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const int minimumChips = 5;
  static const String savedTablesKey = 'saved_tables';
  static const double chipSpacing = 8.0;
  static const double defaultPadding = 4.0;
  static const double chipAvatarRadius = 40.0;
  static const double chipBorderRadius = 8.0;
  static const double chipHorizontalPadding = 16.0;
  static const double chipVerticalPadding = 12.0;
  static const String rootRoute = '/';
  static const String chipTableRoute = '/chip_table';
  static const String savedTablesRoute = '/saved_tables';
  static const String startButtonHeroTag = 'start_button_hero';
  static const String addButtonHeroTag = 'add_button_hero';
  static const String restartButtonHeroTag = 'restart_button_hero';
  static const String saveButtonHeroTag = 'save_button_hero';

  static ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    fontFamily: GoogleFonts.roboto().fontFamily,
    textTheme: GoogleFonts.robotoTextTheme()
  );

  AppConstants._();
}