import 'package:bingo_it/pages/chip_table_page.dart';
import 'package:bingo_it/pages/home_page.dart';
import 'package:bingo_it/pages/table_drafts_page.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentTable(),
      child: MaterialApp(
        title: 'Bingo It!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        routes: {
          '/': (context) => HomePage(),
          '/chipTable': (context) => ChipTablePage(),
          '/savedTables': (context) => TableDraftsPage(),
        },
      )
    );
    
  }
}
