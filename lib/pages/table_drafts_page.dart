import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/state/current_table.dart';

class TableDraftsPage extends StatefulWidget {
  const TableDraftsPage({super.key});

  @override
  State<TableDraftsPage> createState() => _TableDraftsPageState();
}

class _TableDraftsPageState extends State<TableDraftsPage> {
  List<ChipTableModel> savedTables = [];
  final String storageKey = 'saved_tables';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedTables();
  }

  Future<void> _loadSavedTables() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tablesJson = prefs.getString(storageKey);

    if (tablesJson != null) {
      final List<dynamic> decoded = jsonDecode(tablesJson);
      setState(() {
        savedTables =
            decoded.map((table) => ChipTableModel.fromJson(table)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTable(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTables.removeAt(index);
    });
    final encoded =
        jsonEncode(savedTables.map((table) => table.toJson()).toList());
    await prefs.setString(storageKey, encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Saved Tables'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedTables.isEmpty
              ? const Center(child: Text('No saved tables yet'))
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
                        title: Text('Table ${index + 1}'),
                        subtitle: Text(
                            '${table.chips.length} items, ${table.completedChips} completed'),
                        onTap: () {
                          Provider.of<CurrentTable>(context, listen: false)
                              .setCurrentTable(table);
                          Navigator.pushNamed(context, '/chipTable');
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
