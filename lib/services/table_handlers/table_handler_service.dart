import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/repository/shared_preferences_repository.dart';

class TableHandlerService {
  final SharedPreferencesRepository _repository = SharedPreferencesRepository();

  Future<void> deleteTable(String id) async {
    final tables = await _repository.getStoredTables();
    tables.removeWhere((table) => table.id == id);
    await _repository.saveTablesToStorage(tables);
  }

  Future<void> insertTable(ChipTableModel table) async {
    final tables = await _repository.getStoredTables();
    tables.add(table);
    await _repository.saveTablesToStorage(tables);
  }

  Future<void> updateTable(String id, ChipTableModel table) async {
    final tables = await _repository.getStoredTables();
    final index = tables.indexWhere((t) => t.id == id);
    if (index >= 0 && index < tables.length) {
      tables[index] = table;
      await _repository.saveTablesToStorage(tables);
    }
  }

  Future<List<ChipTableModel>> getSavedTables() async {
    return await _repository.getStoredTables();
  }
}