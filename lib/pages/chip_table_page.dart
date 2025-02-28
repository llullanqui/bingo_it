import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:flutter/material.dart';

class ChipTablePage extends StatefulWidget {
  const ChipTablePage({super.key, required this.chipTable});

  final ChipTable chipTable;

  @override
  State<ChipTablePage> createState() => _ChipTablePageState();
}

class _ChipTablePageState extends State<ChipTablePage> {
  ChipTable? chipTable;
  String textboxValue = "";
  bool readyToPlay = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    chipTable = widget.chipTable;
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool _minimumAmountFilled() {
    return chipTable!.chipsAmount >= 5;
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

  Widget _notReadyActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _startButton(),
        const SizedBox(
          width: 4,
        ),
        _addButton(),
      ],
    );
  }

  Widget _readyActions() {
    return _restartButton();
  }

  List<Widget> chipsTableWidget() {
    if (chipTable?.chips == null) {
      return List.empty();
    }
    List<Widget> widgetList = List.empty(growable: true);
    for (var element in chipTable!.chips) {
      widgetList.add(BingoChip(
        text: element.text,
        onDelete: () {},
        onDone: () {},
        container: [],
      ));
    }
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
          child: Wrap(
            spacing: 8.0,
            children: chipsTableWidget(),
          ),
        ),
        floatingActionButton:
            readyToPlay ? _readyActions() : _notReadyActions());
  }
}
