import 'package:bingo_it/models/chip_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/state/current_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).appTitle,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Provider.of<CurrentTable>(context, listen: false)
                              .currentTable = ChipTableModel.empty();
                  Navigator.pushNamed(context, AppConstants.chipTableRoute);
                },
                child: Text(AppLocalizations.of(context).newTable),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppConstants.savedTablesRoute);
                },
                child: Text(AppLocalizations.of(context).savedTables),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
