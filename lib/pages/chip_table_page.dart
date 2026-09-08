import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/enums/chip_table_page_status.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/services/table_storage_service.dart';
import 'package:bingo_it/state/current_chip_table_status.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:bingo_it/widgets/chip_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

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
  ConfettiController? _confettiController;

  /// call the kill method to kill the confetti
  /// controller.kill();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _confettiController = ConfettiController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chipTable = Provider.of<CurrentTable>(context, listen: false).currentTable;
  }

  @override
  void dispose() {
    _textController.dispose();
    _confettiController?.kill();
    super.dispose();
  }

  bool _minimumAmountFilled() {
    return chipTable!.chipsAmount >= AppConstants.minimumChips;
  }

  Future<void> _saveTable() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).saving),
        duration: Duration(seconds: 1),
      ),
    );

    await TableStorageService.saveTable(chipTable!);

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
    pageStatus = ChipTablePageStatus.setup;
    _confettiController?.kill();
  }

  void _notReadyYetAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)
                .addAtLeastItems(AppConstants.minimumChips)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(AppLocalizations.of(context).ok)),
            ],
          );
        });
  }

  Widget _startButton() {
    return FloatingActionButton(
      heroTag: AppConstants.startButtonHeroTag,
      onPressed: () async {
        if (!_minimumAmountFilled()) {
          _notReadyYetAlert();
        } else {
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
      tooltip: AppLocalizations.of(context).add,
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
      heroTag: AppConstants.saveButtonHeroTag,
      onPressed: () async {
        if (!_minimumAmountFilled()) {
          _notReadyYetAlert();
        } else {
          final result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).saveTable),
                  content: TextField(
                    controller: _textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).saveTableHint),
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
                          chipTable!.name = _textController.text;
                          _textController.clear();
                        },
                        child: Text(AppLocalizations.of(context).save)),
                  ],
                );
              });
          if (result != null) {
            result as String;
            _saveTable();
          }
        }
      },
      tooltip: AppLocalizations.of(context).saveTable,
      child: const Icon(Icons.save),
    );
  }

  Widget _actions() {
    if (pageStatus == ChipTablePageStatus.playing) {
      return _playingActions();
    } else if (pageStatus == ChipTablePageStatus.completed) {
      return _setupActions();
    } else {
      return _setupActions();
    }
  }

  Widget _setupActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _saveDraftButton(),
        const SizedBox(
          width: 4,
        ),
        _startButton(),
        const SizedBox(
          width: 4,
        ),
        _addButton(),
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

  Widget _completedPercentage() {
    return Visibility(
      visible: pageStatus == ChipTablePageStatus.playing,
      child: Consumer<CurrentChipTableStatus>(
        builder: (context, chipTableStatus, child) {
          return Text(
            chipTableStatus.completionPercentage,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }

  Widget completedMessage() {
    return Consumer<CurrentChipTableStatus>(
      builder: (context, chipTableStatus, child) {
        if (chipTableStatus.isCompleted) {
          pageStatus = ChipTablePageStatus.completed;
          // _confettiController?.launch();
        }
        return Visibility(
          visible: chipTableStatus.isCompleted,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Confetti(
                      controller: _confettiController!,
                      options: const ConfettiOptions(
                        particleCount: 100,
                        spread: 70, 
                        y: 0.6,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).youWin,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context).appTitle),
          actions: [
            _completedPercentage(),
          ],
        ),
        body: Center(
            child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            ChipTable(
              chipTable: chipTable,
              playing: pageStatus == ChipTablePageStatus.playing,
            ),
            completedMessage(),
          ],
        )),
        floatingActionButton: _actions());
  }
}
