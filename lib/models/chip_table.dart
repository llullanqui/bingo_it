import 'package:bingo_it/models/chip.dart';

class ChipTableModel {
  List<ChipModel> _chips = List.empty(growable: true);
  int _totalChips = 0;
  int _doneChips = 0;
  bool _completed = false;

  int get completedChips => _doneChips;

  Map<String, dynamic> toJson() {
    return {
      'chips': _chips.map((chip) => {'text': chip.text, 'done': chip.done}).toList(),
      'totalChips': _totalChips,
      'doneChips': _doneChips,
      'completed': _completed,
    };
  }

  factory ChipTableModel.fromJson(Map<String, dynamic> json) {
    final table = ChipTableModel.empty();
    final chipsList = (json['chips'] as List);
    for (var chipData in chipsList) {
      if (chipData['done']) {
        table._chips.add(ChipModel.withDone(chipData['text'], true, table));
        table._doneChips++;
      } else {
        table._chips.add(ChipModel(chipData['text'], table));
      }
    }
    table._totalChips = json['totalChips'];
    table._completed = json['completed'];
    return table;
  }

  ChipTableModel(this._chips) {
    _totalChips = _chips.length;
  }
  ChipTableModel.empty();

  List<ChipModel> get chips {
    return _chips;
  }

  int get chipsAmount {
    return _totalChips;
  }

  bool get isCompleted {
    return _completed;
  }

  void _updateCompleted() {
    _completed = _totalChips > 0 && _totalChips - _doneChips == 0;
  }

  void addCompletedChip() {
    _doneChips += 1;
    _updateCompleted();
  }

  void removeCompletedChip() {
    _doneChips -= 1;
    _updateCompleted();
  }

  void addChip(String text) {
    _chips.add(ChipModel(text, this));
    _totalChips += 1;
    _updateCompleted();
  }

  void removeChip(ChipModel chip) {
    if (chip.done) _doneChips -= 1;
    _chips.remove(chip);
    _totalChips = _chips.length;
    _updateCompleted();
  }

  void restartTable() {
    for (var element in chips.where((chip) => chip.done)) {
      element.toggle();
    }
    _doneChips = 0;
    _updateCompleted();
  }

  void emptyTable() {
    _chips = List.empty(growable: true);
    _totalChips = 0;
    _doneChips = 0;
    _completed = false;
  }
}
