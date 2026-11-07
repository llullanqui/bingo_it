import 'package:bingo_it_all/models/chip_table_column.dart';
import 'package:bingo_it_all/models/chip_table.dart';

class ChipModel {
  bool _done = false;
  final String _text;
  final ChipTableModel _table;
  ChipTableColumnModel? category;
  int? row;
  int order;

  ChipModel.withDone(this._text, this._done, this._table, {this.category, this.row = 0, this.order = 0});
  ChipModel(this._text, this._table, {this.category, this.row = 0, this.order = 0});

  bool get done {
    return _done;
  }

  String get text {
    return _text;
  }

  void toggle() {
    _done = !_done;
    _done ? _table.addCompletedChip() : _table.removeCompletedChip();
  }

  void takeAwayFromTable() {
    _table.removeChip(this);
  }

  Comparator<ChipModel> get comparatorByRowAndCategory {
    return (a, b) {
      final rowComparison = (a.row ?? 0).compareTo(b.row ?? 0);
      if (rowComparison != 0) return rowComparison;

      return (a.category?.order ?? 0).compareTo(b.category?.order ?? 0);
    };
  }

}
