import 'dart:convert';
import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/enums/chip_table_page_status.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChipTablePage extends StatefulWidget {
  const ChipTablePage({super.key});

  @override
  State<ChipTablePage> createState() => ChipTablePageState();
}

class ChipTablePageState extends State<ChipTablePage> {
  ChipTableModel? chipTable;
  String textboxValue = "";
  ChipTablePageStatus pageStatus = ChipTablePageStatus.setup;
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
    return chipTable!.chipsAmount >= AppConstants.minimumChips;
  }

  Future<void> _saveTable() async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingTablesJson = prefs.getString(AppConstants.savedTablesKey);
    List<ChipTableModel> savedTables = [];

    if (existingTablesJson != null) {
      final List<dynamic> decoded = jsonDecode(existingTablesJson);
      savedTables =
          decoded.map((table) => ChipTableModel.fromJson(table)).toList();
    }

    savedTables.add(chipTable!);
    final encoded =
        jsonEncode(savedTables.map((table) => table.toJson()).toList());
    await prefs.setString(AppConstants.savedTablesKey, encoded);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).tableSaved)),
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
          title: Text(AppLocalizations.of(context).addAtLeastItems(AppConstants.minimumChips)),
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
      heroTag: AppConstants.startButtonHeroTag,
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).readyToStart),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(AppLocalizations.of(context).no)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(AppLocalizations.of(context).letsGo)),
                ],
              );
            });
        if (result && !_minimumAmountFilled()) {
          _notReadyYetAlert();
        } else if (result && _minimumAmountFilled()) {
          setState(() {
            pageStatus = ChipTablePageStatus.playing;
          });
        }
      },
      tooltip: AppLocalizations.of(context).startGame,
      child: const Icon(Icons.star_rate_outlined),
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      heroTag: AppConstants.addButtonHeroTag,
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).add),
                content: TextField(
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).addItemHint),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _textController.clear();
                      },
                      child: Text(AppLocalizations.of(context).cancel)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, _textController.text);
                        _textController.clear();
                      },
                      child: Text(AppLocalizations.of(context).add)),
                ],
              );
            });
        if (result != null) {
          result as String;
          _addBingoChip(result);
        }
      },
      tooltip: AppLocalizations.of(context).increment,
      child: const Icon(Icons.add),
    );
  }

  Widget _restartButton() {
    return FloatingActionButton(
      heroTag: AppConstants.restartButtonHeroTag,
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).sureToRestart),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(AppLocalizations.of(context).no)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(AppLocalizations.of(context).yes)),
                ],
              );
            });
        if (result) {
          restartTable();
          setState(() {
            pageStatus = ChipTablePageStatus.setup;
          });
        }
      },
      tooltip: AppLocalizations.of(context).restart,
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

  Widget _actions() {
    if(pageStatus == ChipTablePageStatus.playing) {
      return _playingActions();
    } else if(pageStatus == ChipTablePageStatus.completed) {
      return _setupActions();
    } else {
      return _setupActions();
    }
  }

  Widget _setupActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _startButton(),
        const SizedBox(
          width: 4,
        ),
        _addButton(),
        const SizedBox(
          width: 4,
        ),
        _saveDraftButton(),
      ],
    );
  }

  Widget _playingActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _restartButton(),
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
        enabled: pageStatus == ChipTablePageStatus.playing,
      ));
    }
    return widgetList;
  }

  List<Widget> stackChildren() {
    List<Widget> widgetList = List.empty(growable: true);
    if (chipTable!.isCompleted) {
      widgetList.add(Text(AppLocalizations.of(context).youWin));
    }
    widgetList.add(Wrap(
      spacing: AppConstants.chipSpacing,
      children: chipsTableWidget(chipTable!.isCompleted),
    ));
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context).appTitle),
        ),
        body: Center(
          child: Stack(
            children: stackChildren(),
          ),
        ),
        floatingActionButton: _actions());
  }
}
