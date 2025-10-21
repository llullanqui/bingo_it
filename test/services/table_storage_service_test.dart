import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bingo_it/services/table_storage_service.dart';
import 'package:bingo_it/models/chip_table.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TableStorageService', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('loadSavedTables returns empty list when no tables saved', () async {
      final tables = await TableStorageService.loadSavedTables();
      expect(tables, isEmpty);
    });

    test('saveTable stores table correctly', () async {
      final table = ChipTableModel.name("Test Table");
      table.addChip('1');
      await TableStorageService.saveTable(table);

      final tables = await TableStorageService.loadSavedTables();
      expect(tables.length, 1);
      expect(tables.first.name, 'Test Table');
      expect(tables.first.chips.first.text, "1");
    });

    test('deleteTable removes correct table', () async {
      final table1 = ChipTableModel.name('Table 1');
      final table2 = ChipTableModel.name('Table 2');

      await TableStorageService.saveTable(table1);
      await TableStorageService.saveTable(table2);
      await TableStorageService.deleteTable(0);

      final tables = await TableStorageService.loadSavedTables();
      expect(tables.length, 1);
      expect(tables.first.name, 'Table 2');
    });

    test('updateTable modifies correct table', () async {
      final table = ChipTableModel.name('Original');
      table.addChip("1");
      await TableStorageService.saveTable(table);

      final updatedTable = ChipTableModel.name('Updated');
      updatedTable.addChip("4");
      await TableStorageService.updateTable(0, updatedTable);

      final tables = await TableStorageService.loadSavedTables();
      expect(tables.length, 1);
      expect(tables.first.name, 'Updated');
      expect(tables.first.chips.first.text, "4");
    });
  });
}
