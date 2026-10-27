import 'dart:math';
import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/enums/classic_bingo_type.dart';
import 'package:bingo_it_all/models/chip.dart';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/models/chip_table_column.dart';

class TableGeneratorService {

  ChipTableModel _generateClassicTable(List<String> columns, int range, int chipsPerColumn, {String? name}) {
    final random = Random();
    ChipTableModel table = ChipTableModel.empty();
    for (var i = 0; i < columns.length; i++) {
      ChipTableColumn column =
          ChipTableColumn(columns[i], order: i + 1);
      table.columns.add(column);
      List<int> numbers = List.generate(
          range, (index) => index + 1 + (i * range)
        )..shuffle(random);
      table.chips.addAll(
        numbers.take(chipsPerColumn)
        .map((number) => ChipModel(number.toString(), table, category: column)));
    }
    if (name != null) {
      table.name = name;
    }
    return table;
  }

  ChipTableModel generateClassicTable({required String name, required ClassicBingoType type}) {
    switch (type) {
      case ClassicBingoType.bingo75:
        return _generateClassicTable(
          AppConstants.classicBingo75Columns,
          AppConstants.classicBingo75Range,
          AppConstants.classicBingo75ChipsPerColumn,
          name: name
        );
      case ClassicBingoType.bingo90:
        return _generateClassicTable(
          AppConstants.classicBingo90Columns,
          AppConstants.classicBingo90Range,
          AppConstants.classicBingo90ChipsPerColumn,
          name: name
        );
    }
  }
  
}
