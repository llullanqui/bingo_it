import 'package:bingo_it_all/models/chip_table.dart';

abstract class AbstractTableGeneratorService{
  ChipTableModel generateTable({required String name});
}