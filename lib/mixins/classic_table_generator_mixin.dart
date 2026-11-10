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
      ChipTableColumnModel column = ChipTableColumnModel(columns[i], order: i + 1);
      table.addColumn(column);
      List<int> numbers =
          List.generate(range, (index) => index + 1 + (i * range))
            ..shuffle(random);
      numbers.take(chipsPerColumn).forEach((number) {
        table.addChip(number.toString(), 
          category: column, 
          row: numbers.indexOf(number) + 1, 
          order: numbers.indexOf(number)*range + i + 1);
      });
    }
    table.numberOfColumns = columns.length;
    if (name != null) {
      table.name = name;
    }
    table.toggleDisplayColumns();
    return table;
  }
}
