import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/services/table_generators/bingo75_generator_service.dart';
import 'package:bingo_it_all/services/table_generators/bingo90_generator_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bingo75GeneratorService', () {
    test('generates a named table with five chips for each letter column', () {
      final table = Bingo75GeneratorService().generateTable(name: '75-ball');

      expect(table.name, '75-ball');
      expect(table.chips, hasLength(25));
      expect(
        table.tableColumns.map((column) => column.name),
        AppConstants.classicBingo75Columns,
      );
      expect(
        table.tableColumns.map((column) => column.order),
        [1, 2, 3, 4, 5],
      );
      for (var index = 0; index < table.tableColumns.length; index++) {
        final column = table.tableColumns[index];
        final chips = table.chips
            .where((chip) => identical(chip.category, column))
            .toList();
        final numbers = chips.map((chip) => int.parse(chip.text)).toList();

        expect(chips, hasLength(5));
        expect(numbers.toSet(), hasLength(5));
        expect(
          numbers,
          everyElement(inInclusiveRange(index * 15 + 1, (index + 1) * 15)),
        );
      }
    });
  });

  group('Bingo90GeneratorService', () {
    test('generates a named table with three chips for each number column', () {
      final table = Bingo90GeneratorService().generateTable(name: '90-ball');

      expect(table.name, '90-ball');
      expect(table.chips, hasLength(27));
      expect(
        table.tableColumns.map((column) => column.name),
        AppConstants.classicBingo90Columns,
      );
      expect(
        table.tableColumns.map((column) => column.order),
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
      );
      for (var index = 0; index < table.tableColumns.length; index++) {
        final column = table.tableColumns[index];
        final chips = table.chips
            .where((chip) => identical(chip.category, column))
            .toList();
        final numbers = chips.map((chip) => int.parse(chip.text)).toList();

        expect(chips, hasLength(3));
        expect(numbers.toSet(), hasLength(3));
        expect(
          numbers,
          everyElement(inInclusiveRange(index * 10 + 1, (index + 1) * 10)),
        );
      }
    });
  });
}
