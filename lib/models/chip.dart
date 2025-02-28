import 'package:bingo_it/models/chip_table.dart';

class Chip {
  bool _done = false;
  final String _text;
  final ChipTable _table;

  Chip.withDone(this._text, this._done, this._table);
  Chip(this._text, this._table);

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
}
