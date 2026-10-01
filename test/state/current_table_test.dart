import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/state/current_chip_table_status.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrentTable', () {
    test('starts with an empty table', () {
      final state = CurrentTable();

      expect(state.currentTable.chips, isEmpty);
      expect(state.currentTable.chipsAmount, 0);
    });

    test('replaces the current table and notifies listeners', () {
      final state = CurrentTable();
      final table = ChipTableModel.empty()..addChip('Item');
      var notifications = 0;
      state.addListener(() => notifications++);

      state.currentTable = table;

      expect(state.currentTable, same(table));
      expect(notifications, 1);
    });
  });

  group('CurrentChipTableStatus', () {
    test('initializes from the current table', () {
      final table = ChipTableModel.empty()..addChip('Item');
      table.chips.single.toggle();

      final state = CurrentChipTableStatus(table);

      expect(state.completionPercentage, '100.00%');
      expect(state.isCompleted, isTrue);
    });

    test('setters update values and notify listeners', () {
      final state = CurrentChipTableStatus(ChipTableModel.empty());
      var notifications = 0;
      state.addListener(() => notifications++);

      state.setCompletionPercentage = '50.00%';
      state.setIsCompleted = true;

      expect(state.completionPercentage, '50.00%');
      expect(state.isCompleted, isTrue);
      expect(notifications, 2);
    });

    test('updateStatus synchronizes values and notifies listeners', () {
      final state = CurrentChipTableStatus(ChipTableModel.empty());
      final table = ChipTableModel.empty()
        ..addChip('First')
        ..addChip('Second');
      table.chips.first.toggle();
      var notifications = 0;
      state.addListener(() => notifications++);

      state.updateStatus(table);

      expect(state.completionPercentage, '50.00%');
      expect(state.isCompleted, isFalse);
      expect(notifications, 1);
    });
  });
}
