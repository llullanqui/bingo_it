import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:bingo_it/services/table_storage_service.dart';

class TableDraftsPage extends StatefulWidget {
  const TableDraftsPage({super.key});

  @override
  State<TableDraftsPage> createState() => _TableDraftsPageState();
}

class _TableDraftsPageState extends State<TableDraftsPage> {
  List<ChipTableModel> savedTables = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedTables();
  }

  Future<void> _loadSavedTables() async {
    final tables = await TableStorageService.loadSavedTables();
    setState(() {
      savedTables = tables;
      isLoading = false;
    });
  }

  Future<void> _deleteTable(int index) async {
    await TableStorageService.deleteTable(index);
    setState(() {
      savedTables.removeAt(index);
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
              ? Center(child: Text(AppLocalizations.of(context).noSavedTablesYet))
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
                      onDismissed: (direction) => _deleteTable(index),
                      child: ListTile(
                        title: Text('${AppLocalizations.of(context).table} #${index + 1}: ${table.name}'),
                        subtitle: Text(AppLocalizations.of(context).tableDraftsSubtitle(table.chips.length)),
                        onTap: () {
                          Provider.of<CurrentTable>(context, listen: false)
                              .currentTable = table;
                          Navigator.popAndPushNamed(context, AppConstants.chipTableRoute);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
