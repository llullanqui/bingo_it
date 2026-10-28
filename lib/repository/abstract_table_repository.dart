import 'package:bingo_it_all/models/chip_table.dart';

abstract interface class AbstractTableRepository {
  Future<List<ChipTableModel>> getStoredTables();
  Future<ChipTableModel?> getTableById(String id);
  Future<void> saveTablesToStorage(List<ChipTableModel> tables);
}