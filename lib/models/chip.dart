import 'package:bingo_it/models/chip_table.dart';

class ChipModel {
  bool _done = false;
  final String _text;
  final ChipTableModel _table;

  ChipModel.withDone(this._text, this._done, this._table);
  ChipModel(this._text, this._table);

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
}
