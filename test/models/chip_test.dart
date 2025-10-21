import 'package:flutter_test/flutter_test.dart';
import 'package:bingo_it/models/chip.dart';
import 'package:bingo_it/models/chip_table.dart';

class FakeChipTable implements ChipTableModel {
  int addCompletedCount = 0;
  int removeCompletedCount = 0;
  final List<dynamic> removedChips = [];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName;
    if (name == #addCompletedChip) {
      addCompletedCount++;
      return null;
    } else if (name == #removeCompletedChip) {
      removeCompletedCount++;
      return null;
    } else if (name == #removeChip) {
      if (invocation.positionalArguments.isNotEmpty) {
        removedChips.add(invocation.positionalArguments.first);
      }
      return null;
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('ChipModel', () {
    test('text and default done are correct', () {
      final table = FakeChipTable();
      final chip = ChipModel('Hello', table);
      expect(chip.text, equals('Hello'));
      expect(chip.done, isFalse);
    });

    test('withDone constructor sets done state', () {
      final table = FakeChipTable();
      final chip = ChipModel.withDone('X', true, table);
      expect(chip.done, isTrue);
      expect(chip.text, equals('X'));
    });

    test('toggle from false to true calls addCompletedChip', () {
      final table = FakeChipTable();
      final chip = ChipModel('A', table);
      expect(chip.done, isFalse);

      chip.toggle();

      expect(chip.done, isTrue);
      expect(table.addCompletedCount, equals(1));
      expect(table.removeCompletedCount, equals(0));
    });

    test('toggle from true to false calls removeCompletedChip', () {
      final table = FakeChipTable();
      final chip = ChipModel.withDone('B', true, table);
      expect(chip.done, isTrue);

      chip.toggle();

      expect(chip.done, isFalse);
      expect(table.removeCompletedCount, equals(1));
      expect(table.addCompletedCount, equals(0));
    });

    test('takeAwayFromTable calls removeChip on table with the chip', () {
      final table = FakeChipTable();
      final chip = ChipModel('C', table);

      chip.takeAwayFromTable();

      expect(table.removedChips.length, equals(1));
      expect(identical(table.removedChips.first, chip), isTrue);
    });
  });
}