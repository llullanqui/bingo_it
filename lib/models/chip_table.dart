import 'package:uuid/uuid.dart';

import 'package:bingo_it_all/models/chip.dart';
import 'package:bingo_it_all/models/chip_table_column.dart';

class ChipTableModel {
  late String id;
  String? name;
  int _totalChips = 0;
  int _doneChips = 0;
  bool _completed = false;
  bool _displayColumns = false;
  List<ChipModel> _chips = List.empty(growable: true);
  List<ChipTableColumnModel> _columns = List.empty(growable: true);

  int get completedChips => _doneChips;

  Map<String, dynamic> toJson() {
    return {
      'chips': _chips
          .map((chip) => {'text': chip.text, 'done': chip.done})
          .toList(),
      'totalChips': _totalChips,
      'doneChips': _doneChips,
      'completed': _completed,
      'name': name,
      'id': id,
      'columns': _columns
          .map(
            (column) => {
              'name': column.name,
              'displayName': column.displayedName,
              'order': column.order,
            },
          )
          .toList(),
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
    table.name = json['name'];
    table.id = json['id'];
    table._columns = (json['columns'] as List)
        .map(
          (columnData) => ChipTableColumnModel(
            columnData['name'],
            displayName: columnData['displayName'],
            order: columnData['order'],
          ),
        )
        .toList();
    return table;
  }

  ChipTableModel(this._chips) {
    var uuid = Uuid();
    id = uuid.v4();
    _totalChips = _chips.length;
  }
  ChipTableModel.name(this.name) {
    var uuid = Uuid();
    id = uuid.v4();
  }
  ChipTableModel.empty() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  List<ChipModel> get sortedChips {
    return _chips..sort((a, b) => a.comparatorByRowAndCategory(a, b));
  }

  List<ChipModel> get chips {
    return _chips;
  }

  List<ChipTableColumnModel> get tableColumns {
    return _columns;
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

  void addChip(String text, {ChipTableColumnModel? category, int? row}) {
    _chips.add(ChipModel(text, this, category: category, row: row));
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
    _columns = List.empty(growable: true);
    _totalChips = 0;
    _doneChips = 0;
    _completed = false;
  }

  String get completionPercentage {
    if (_totalChips == 0) return "0%";
    return "${(_doneChips / _totalChips * 100).toStringAsFixed(2)}%";
  }

  void addColumn(ChipTableColumnModel column) {
    _columns.add(column);
  }

  bool displayColumns() {
    return _displayColumns;
  }

  void toggleDisplayColumns() {
    _displayColumns = !_displayColumns;
  }
}
