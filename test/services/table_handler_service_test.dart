import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/services/table_handlers/table_handler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TableHandlerService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = TableHandlerService();
  });

  group('TableHandlerService', () {
    test('returns an empty list when there are no saved tables', () async {
      expect(await service.getSavedTables(), isEmpty);
    });

    test('inserts and reads a table with its data intact', () async {
      final table = ChipTableModel.name('Weekend')..addChip('Take a trip');

      await service.insertTable(table);

      final savedTables = await service.getSavedTables();
      expect(savedTables, hasLength(1));
      expect(savedTables.single.id, table.id);
      expect(savedTables.single.name, 'Weekend');
      expect(savedTables.single.chips.single.text, 'Take a trip');
    });

    test('deletes only the table with the requested ID', () async {
      final firstTable = ChipTableModel.name('First');
      final secondTable = ChipTableModel.name('Second');
      await service.insertTable(firstTable);
      await service.insertTable(secondTable);

      await service.deleteTable(firstTable.id);

      final savedTables = await service.getSavedTables();
      expect(savedTables, hasLength(1));
      expect(savedTables.single.id, secondTable.id);
    });

    test('updates an existing table', () async {
      final original = ChipTableModel.name('Original')..addChip('Old item');
      final updated = ChipTableModel.name('Updated')..addChip('New item');
      await service.insertTable(original);

      await service.updateTable(original.id, updated);

      final savedTables = await service.getSavedTables();
      expect(savedTables, hasLength(1));
      expect(savedTables.single.name, 'Updated');
      expect(savedTables.single.chips.single.text, 'New item');
    });

    test('does not add or replace a table when the update ID is missing',
        () async {
      final original = ChipTableModel.name('Original');
      await service.insertTable(original);
      final replacement = ChipTableModel.name('Replacement');

      await service.updateTable('missing-id', replacement);

      final savedTables = await service.getSavedTables();
      expect(savedTables, hasLength(1));
      expect(savedTables.single.id, original.id);
      expect(savedTables.single.name, 'Original');
    });
  });
}
