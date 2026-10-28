import 'dart:convert';
import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/repository/abstract_table_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bingo_it_all/models/chip_table.dart';

class SharedPreferencesRepository implements AbstractTableRepository {
  SharedPreferencesRepository._privateConstructor();
  static final SharedPreferencesRepository _instance = SharedPreferencesRepository._privateConstructor();
  factory SharedPreferencesRepository() {
    return _instance;
  }

  /// Loads all saved tables from SharedPreferences
  @override
  Future<List<ChipTableModel>> getStoredTables() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tablesJson = prefs.getString(AppConstants.savedTablesKey);

    if (tablesJson != null) {
      final List<dynamic> decoded = jsonDecode(tablesJson);
      return decoded.map((table) => ChipTableModel.fromJson(table)).toList();
    }
    return [];
  }

  @override
  Future<void> saveTablesToStorage(List<ChipTableModel> tables) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tables.map((table) => table.toJson()).toList());
    await prefs.setString(AppConstants.savedTablesKey, encoded);
  }

  @override
  Future<ChipTableModel?> getTableById(String id) async {
    final tables = await getStoredTables();
    for (final table in tables) {
      if (table.id == id) return table;
    }
    return null;
  }
}
