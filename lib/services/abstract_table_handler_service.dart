import 'package:bingo_it_all/models/chip_table.dart';

abstract class AbstractTableHandlerService {
  Future<List<ChipTableModel>> getAllTables();
  Future<ChipTableModel?> getTableById(String id);
  Future<void> deleteTable(String id);
  Future<void> insertTable(ChipTableModel table);
  Future<void> updateTable(String id, ChipTableModel table);
}