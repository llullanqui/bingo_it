import 'package:bingo_it/pages/chip_table_page.dart';
import 'package:bingo_it/pages/home_page.dart';
import 'package:bingo_it/pages/table_drafts_page.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/state/current_chip_table_status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    return ChangeNotifierProvider(
        create: (context) => CurrentTable(),
        child: MaterialApp(
          title: 'Bingo It!',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(theme),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          localeListResolutionCallback: (locales, supportedLocales) {
            for (Locale locale in locales!) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
            }
            return const Locale('en', 'US');
          },
          routes: {
            AppConstants.rootRoute: (context) => HomePage(),
            AppConstants.chipTableRoute: (context) => ChangeNotifierProvider(
              create: (context) => CurrentChipTableStatus(Provider.of<CurrentTable>(context, listen: false).currentTable),
              child: ChipTablePage()
            ),
            AppConstants.savedTablesRoute: (context) => TableDraftsPage(),
          },
        ));
  }
}

ThemeData _buildTheme(ThemeData baseTheme) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    fontFamily: GoogleFonts.roboto().fontFamily,
    textTheme: baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
    ).textTheme,
  );
}