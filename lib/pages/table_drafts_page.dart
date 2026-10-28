import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/services/table_handlers/table_handler_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/state/current_table.dart';

class TableDraftsPage extends StatefulWidget {
  const TableDraftsPage({super.key});

  @override
  State<TableDraftsPage> createState() => _TableDraftsPageState();
}

class _TableDraftsPageState extends State<TableDraftsPage> {
  List<ChipTableModel> savedTables = [];
  bool isLoading = true;
  final TableHandlerService tableHandlerService = TableHandlerService();

  @override
  void initState() {
    super.initState();
    _loadSavedTables();
  }

  Future<void> _loadSavedTables() async {
    final tables = await tableHandlerService.getSavedTables();
    setState(() {
      savedTables = tables;
      isLoading = false;
    });
  }

  Future<void> _deleteTable(ChipTableModel table) async {
    await tableHandlerService.deleteTable(table.id);
    setState(() {
      savedTables.remove(table);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context).savedTables),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedTables.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context).noSavedTablesYet))
              : ListView.builder(
                  itemCount: savedTables.length,
                  itemBuilder: (context, index) {
                    final table = savedTables[index];
                    return Dismissible(
                      key: Key('table_$index'),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => _deleteTable(table),
                      child: ListTile(
                        title: Text(
                            '${AppLocalizations.of(context).table} #${index + 1}: ${table.name}'),
                        subtitle: Text(AppLocalizations.of(context)
                            .tableDraftsSubtitle(table.chips.length)),
                        onTap: () {
                          Provider.of<CurrentTable>(context, listen: false)
                              .currentTable = table;
                          Navigator.popAndPushNamed(
                              context, AppConstants.chipTableRoute);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
