import 'package:bingo_it/models/chip_table.dart';
import 'package:flutter/widgets.dart';

class CurrentTable extends ChangeNotifier {

  ChipTableModel _currentTable = ChipTableModel.empty();
  ChipTableModel get currentTable => _currentTable;

  void setCurrentTable(ChipTableModel table) {
    _currentTable = table;
    notifyListeners();
  }

}