import 'dart:convert';
import 'package:bingo_it/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bingo_it/models/chip_table.dart';

class TableStorageService {

  /// Loads all saved tables from SharedPreferences
  static Future<List<ChipTableModel>> loadSavedTables() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tablesJson = prefs.getString(AppConstants.savedTablesKey);

    if (tablesJson != null) {
      final List<dynamic> decoded = jsonDecode(tablesJson);
      return decoded.map((table) => ChipTableModel.fromJson(table)).toList();
    }
    return [];
  }

  /// Deletes a table at the specified index
  static Future<void> deleteTable(int index) async {
    final tables = await loadSavedTables();

    if (index >= 0 && index < tables.length) {
      tables.removeAt(index);
      await _saveTables(tables);
    }
  }

  /// Saves a new table to the storage
  static Future<void> saveTable(ChipTableModel table) async {
    final tables = await loadSavedTables();
    tables.add(table);
    await _saveTables(tables);
  }

  /// Updates an existing table at the specified index
  static Future<void> updateTable(int index, ChipTableModel table) async {
    final tables = await loadSavedTables();

    if (index >= 0 && index < tables.length) {
      tables[index] = table;
      await _saveTables(tables);
    }
  }

  /// Internal method to save tables to SharedPreferences
  static Future<void> _saveTables(List<ChipTableModel> tables) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tables.map((table) => table.toJson()).toList());
    await prefs.setString(AppConstants.savedTablesKey, encoded);
  }
}
