import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/state/current_chip_table_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrentChipTableStatus', () {
    test('initializes from an empty table', () {
      final state = CurrentChipTableStatus(ChipTableModel.empty());

      expect(state.completionPercentage, '0%');
      expect(state.isCompleted, isFalse);
    });

    test('initializes from a completed table', () {
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
      expect(state.completionPercentage, '50.00%');
      expect(notifications, 1);

      state.setIsCompleted = true;
      expect(state.isCompleted, isTrue);
      expect(notifications, 2);
    });

    test('updateStatus synchronizes a partially completed table', () {
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

    test('updateStatus reflects completed and empty tables', () {
      final state = CurrentChipTableStatus(ChipTableModel.empty());
      final completedTable = ChipTableModel.empty()..addChip('Item');
      completedTable.chips.single.toggle();
      var notifications = 0;
      state.addListener(() => notifications++);

      state.updateStatus(completedTable);

      expect(state.completionPercentage, '100.00%');
      expect(state.isCompleted, isTrue);

      state.updateStatus(ChipTableModel.empty());

      expect(state.completionPercentage, '0%');
      expect(state.isCompleted, isFalse);
      expect(notifications, 2);
    });
  });
}
