import 'package:bingo_it_all/models/chip_table.dart';
import 'package:flutter/widgets.dart';

class CurrentChipTableStatus with ChangeNotifier {
  String completionPercentage = "";
  bool isCompleted = false;

  CurrentChipTableStatus(ChipTableModel table) {
    completionPercentage = table.completionPercentage;
    isCompleted = table.isCompleted;
  }

  set setCompletionPercentage(String percentage) {
    completionPercentage = percentage;
    notifyListeners();
  }

  set setIsCompleted(bool completed) {
    isCompleted = completed;
    notifyListeners();
  }

  void updateStatus(ChipTableModel table) {
    completionPercentage = table.completionPercentage;
    isCompleted = table.isCompleted;
    notifyListeners();
  }
}
