import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/state/current_table.dart';
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
}
