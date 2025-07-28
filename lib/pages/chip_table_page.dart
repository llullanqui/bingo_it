import 'dart:convert';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChipTablePage extends StatefulWidget {
  const ChipTablePage({super.key});

  @override
  State<ChipTablePage> createState() => _ChipTablePageState();
}

class _ChipTablePageState extends State<ChipTablePage> {
  ChipTableModel? chipTable;
  String textboxValue = "";
  bool readyToPlay = false;
  bool playing = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chipTable = Provider.of<CurrentTable>(context, listen: false).currentTable;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool _minimumAmountFilled() {
    return chipTable!.chipsAmount >= 5;
  }

  Future<void> _saveTable() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingTablesJson = prefs.getString('saved_tables');
    List<ChipTableModel> savedTables = [];

    if (existingTablesJson != null) {
      final List<dynamic> decoded = jsonDecode(existingTablesJson);
      savedTables =
          decoded.map((table) => ChipTableModel.fromJson(table)).toList();
    }

    savedTables.add(chipTable!);
    final encoded =
        jsonEncode(savedTables.map((table) => table.toJson()).toList());
    await prefs.setString('saved_tables', encoded);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Table saved successfully!')),
    );
  }

  void _addBingoChip(String text) {
    setState(() {
      chipTable!.addChip(text);
    });
  }

  void restartTable() {
    setState(() {
      chipTable!.restartTable();
    });
  }

  void _notReadyYetAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add at least 5 items"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  Widget _startButton() {
    return FloatingActionButton(
      heroTag: "start_button",
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Ready to start?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Let's go!")),
                ],
              );
            });
        if (result && !_minimumAmountFilled()) {
          _notReadyYetAlert();
        } else if (result && _minimumAmountFilled()) {
          setState(() {
            readyToPlay = true;
          });
        }
      },
      tooltip: 'Play!',
      child: const Icon(Icons.star_rate_outlined),
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      heroTag: "add_button",
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Ready to start?"),
                content: TextField(
                  controller: _textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: "Write the item you think will happen"),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _textController.clear();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, _textController.text);
                        _textController.clear();
                      },
                      child: const Text('Add')),
                ],
              );
            });
        if (result != null) {
          result as String;
          _addBingoChip(result);
        }
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  Widget _restartButton() {
    return FloatingActionButton(
      heroTag: "restart_button",
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Sure you want to restart?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Yes")),
                ],
              );
            });
        if (result) {
          restartTable();
        } else if (result) {
          setState(() {
            readyToPlay = true;
          });
        }
      },
      tooltip: 'Restart',
      child: const Icon(Icons.restart_alt),
    );
  }

  Widget _saveDraftButton() {
    return FloatingActionButton(
      heroTag: "save_button",
      onPressed: _saveTable,
      tooltip: 'Save Table',
      child: const Icon(Icons.save),
    );
  }

  Widget _notReadyActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _startButton(),
        const SizedBox(
          width: 4,
        ),
        _addButton(),
        if (chipTable!.chipsAmount > 0) ...[
          const SizedBox(
            width: 4,
          ),
          _saveDraftButton(),
        ],
      ],
    );
  }

  Widget _readyActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _restartButton(),
        const SizedBox(
          width: 4,
        ),
        _saveDraftButton(),
      ],
    );
  }

  List<Widget> chipsTableWidget(bool completed) {
    if (chipTable?.chips == null) {
      return List.empty();
    }
    List<Widget> widgetList = List.empty(growable: true);
    for (var element in chipTable!.chips) {
      widgetList.add(BingoChip(
        chip: element,
        onDelete: () {
          setState(() {});
        },
        onDone: () {
          setState(() {});
        },
        enabled: readyToPlay,
      ));
    }
    return widgetList;
  }

  List<Widget> stackChildren() {
    List<Widget> widgetList = List.empty(growable: true);
    if (chipTable!.isCompleted) {
      widgetList.add(Text("YOU WIN!"));
    }
    widgetList.add(Wrap(
      spacing: 8.0,
      children: chipsTableWidget(chipTable!.isCompleted),
    ));
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Bingo it!"),
        ),
        body: Center(
          child: Stack(
            children: stackChildren(),
          ),
        ),
        floatingActionButton:
            readyToPlay ? _readyActions() : _notReadyActions());
  }
}
