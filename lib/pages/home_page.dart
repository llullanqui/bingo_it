import 'package:bingo_it_all/services/table_generators/bingo75_generator_service.dart';
import 'package:bingo_it_all/services/table_generators/bingo90_generator_service.dart';
import 'package:bingo_it_all/services/table_generators/empty_generator_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/state/current_table.dart';
import 'package:bingo_it_all/widgets/main_page_button.dart';

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
            const SizedBox(height: AppConstants.homePageSpacing),
            MainPageButton(
              AppLocalizations.of(context).classic75Bingo,
              onPressed: () {
                final service = Bingo75GeneratorService();
                Provider.of<CurrentTable>(
                  context,
                  listen: false,
                ).currentTable = service.generateTable(
                  name: AppLocalizations.of(context).classicBingo,
                );
                Navigator.pushNamed(context, AppConstants.chipTableRoute);
              },
            ),
            const SizedBox(height: AppConstants.homePageButtonSpacing),
            MainPageButton(
              AppLocalizations.of(context).classic90Bingo,
              onPressed: () {
                final service = Bingo90GeneratorService();
                Provider.of<CurrentTable>(
                  context,
                  listen: false,
                ).currentTable = service.generateTable(
                  name: AppLocalizations.of(context).classicBingo,
                );
                Navigator.pushNamed(context, AppConstants.chipTableRoute);
              },
            ),
            const SizedBox(height: AppConstants.homePageButtonSpacing),
            MainPageButton(
              AppLocalizations.of(context).newTable,
              onPressed: () {
                Provider.of<CurrentTable>(context, listen: false).currentTable =
                    EmptyGeneratorService()
                    .generateTable(name: AppLocalizations.of(context).newTable);
                Navigator.pushNamed(context, AppConstants.chipTableRoute);
              },
            ),
            const SizedBox(height: AppConstants.homePageButtonSpacing),
            MainPageButton(
              AppLocalizations.of(context).savedTables,
              onPressed: () {
                Navigator.pushNamed(context, AppConstants.savedTablesRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
