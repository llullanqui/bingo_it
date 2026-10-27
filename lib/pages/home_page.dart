import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/services/table_generator_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/state/current_table.dart';
import 'package:bingo_it_all/enums/classic_bingo_type.dart';
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
                final service = TableGeneratorService();
                Provider.of<CurrentTable>(context, listen: false)
                .currentTable = service.generateClassicTable(  
                  name: AppLocalizations.of(context).classicBingo, 
                  type: ClassicBingoType.bingo75
                );
                Navigator.pushNamed(context, AppConstants.chipTableRoute);
              },
            ),
            const SizedBox(height: AppConstants.homePageButtonSpacing),
            MainPageButton(
              AppLocalizations.of(context).classic90Bingo,
              onPressed: () {
                final service = TableGeneratorService();
                Provider.of<CurrentTable>(context, listen: false)
                .currentTable = service.generateClassicTable(  
                  name: AppLocalizations.of(context).classicBingo, 
                  type: ClassicBingoType.bingo90
                );
                Navigator.pushNamed(context, AppConstants.chipTableRoute);
              },
            ),
            const SizedBox(height: AppConstants.homePageButtonSpacing),
            MainPageButton(
              AppLocalizations.of(context).newTable,
              onPressed: () {
                Provider.of<CurrentTable>(context, listen: false).currentTable =
                    ChipTableModel.empty();
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
