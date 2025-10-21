import 'package:flutter_test/flutter_test.dart';
import 'package:bingo_it/models/chip_table.dart';

void main() {
  group('ChipTableModel', () {
    test('initial state is empty and not completed', () {
      final table = ChipTableModel.empty();

      expect(table.chips, isEmpty);
      expect(table.chipsAmount, 0);
      expect(table.completedChips, 0);
      expect(table.isCompleted, isFalse);
      expect(table.name, isNull);
    });

    test('adding chips updates counts and preserves text/done state', () {
      final table = ChipTableModel.empty();

      table.addChip('A');
      table.addChip('B');

      expect(table.chipsAmount, 2);
      expect(table.chips.length, 2);
      expect(table.chips[0].text, 'A');
      expect(table.chips[1].text, 'B');
      expect(table.chips[0].done, isFalse);
      expect(table.completedChips, 0);

      // Toggle first chip -> should mark it done
      table.chips[0].toggle();
      expect(table.completedChips, 1);
      expect(table.isCompleted, isFalse);

      // Toggle second chip -> all done -> completed becomes true
      table.chips[1].toggle();
      expect(table.completedChips, 2);
      expect(table.isCompleted, isTrue);

      // Remove a done chip -> counts update and completed resets
      final removed = table.chips[1];
      table.removeChip(removed);
      expect(table.chipsAmount, 1);
      expect(table.completedChips, 1);
      expect(table.isCompleted, isTrue);
    });

    test(
        'restartTable resets done flags and counters, emptyTable clears everything',
        () {
      final table = ChipTableModel.empty();

      table.addChip('1');
      table.addChip('2');
      table.addChip('3');

      // Mark two as done
      table.chips[0].toggle();
      table.chips[2].toggle();
      expect(table.completedChips, 2);
      expect(table.isCompleted, isFalse);

      // Restart -> all chips become not done
      table.restartTable();
      expect(table.completedChips, 0);
      expect(table.isCompleted, isFalse);
      for (var c in table.chips) {
        expect(c.done, isFalse);
      }

      // Empty table
      table.emptyTable();
      expect(table.chips, isEmpty);
      expect(table.chipsAmount, 0);
      expect(table.completedChips, 0);
      expect(table.isCompleted, isFalse);
    });

    test('toJson and fromJson roundtrip preserves state', () {
      final table = ChipTableModel.empty();
      table.addChip('X');
      table.addChip('Y');
      table.addChip('Z');
      table.name = "My Table";

      // Mark X and Z as done
      table.chips[0].toggle();
      table.chips[2].toggle();

      final json = table.toJson();
      final restored = ChipTableModel.fromJson(json);

      expect(restored.chipsAmount, table.chipsAmount);
      expect(restored.completedChips, table.completedChips);
      expect(restored.isCompleted, table.isCompleted);
      expect(restored.name, table.name);

      for (var i = 0; i < table.chipsAmount; i++) {
        expect(restored.chips[i].text, table.chips[i].text);
        expect(restored.chips[i].done, table.chips[i].done);
      }
    });
  });
}
