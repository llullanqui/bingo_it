import 'package:bingo_it_all/mixins/classic_table_generator_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClassicTableGenerator with ClassicTableGeneratorMixin {}

void main() {
  group('ClassicTableGeneratorMixin', () {
    test('generates chips in the configured ranges for each column', () {
      final generator = TestClassicTableGenerator();

      final table = generator.generateClassicTable(
        ['B', 'I', 'N'],
        10,
        4,
        name: 'Test table',
      );

      expect(table.name, 'Test table');
      expect(table.chipsAmount, 12);
      expect(table.chips, hasLength(12));
      expect(
        table.columns.map((column) => column.name),
        ['B', 'I', 'N'],
      );
      expect(
        table.columns.map((column) => column.order),
        [1, 2, 3],
      );

      for (var index = 0; index < table.columns.length; index++) {
        final column = table.columns[index];
        final columnChips =
            table.chips.where((chip) => identical(chip.category, column));
        final numbers =
            columnChips.map((chip) => int.parse(chip.text)).toList();
        final rangeStart = index * 10 + 1;
        final rangeEnd = rangeStart + 9;

        expect(numbers, hasLength(4));
        expect(numbers.toSet(), hasLength(4));
        expect(numbers, everyElement(inInclusiveRange(rangeStart, rangeEnd)));
      }
    });

    test('leaves the name unset and caps chips at the column range size', () {
      final generator = TestClassicTableGenerator();

      final table = generator.generateClassicTable(['Only'], 2, 5);

      expect(table.name, isNull);
      expect(table.columns, hasLength(1));
      expect(table.chips, hasLength(2));
      expect(
        table.chips.map((chip) => int.parse(chip.text)).toSet(),
        {1, 2},
      );
      expect(
        table.chips.every((chip) => identical(chip.category, table.columns[0])),
        isTrue,
      );
    });
  });
}
