import 'dart:math';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/models/chip_table_column.dart';

mixin ClassicTableGeneratorMixin {
  ChipTableModel generateClassicTable(
      List<String> columns, int range, int chipsPerColumn,
      {String? name}) {
    final random = Random();
    ChipTableModel table = ChipTableModel.empty();
    for (var i = 0; i < columns.length; i++) {
      ChipTableColumn column = ChipTableColumn(columns[i], order: i + 1);
      table.columns.add(column);
      List<int> numbers =
          List.generate(range, (index) => index + 1 + (i * range))
            ..shuffle(random);
      for (final number in numbers.take(chipsPerColumn)) {
        table.addChip(number.toString(), category: column);
      }
    }
    if (name != null) {
      table.name = name;
    }
    return table;
  }
}
