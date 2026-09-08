import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/state/current_chip_table_status.dart';
import 'package:flutter/material.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:provider/provider.dart';

class ChipTable extends StatefulWidget {
  final ChipTableModel? chipTable;
  final bool playing;
  final Function? onCompletionChanged;

  const ChipTable(
      {super.key,
      this.chipTable,
      this.onCompletionChanged,
      this.playing = true});

  @override
  State<ChipTable> createState() => _ChipTableState();
}

class _ChipTableState extends State<ChipTable> {

  List<Widget> chipsTableWidget(bool completed) {
    if (widget.chipTable?.chips == null) {
      return List.empty();
    }
    List<Widget> widgetList = List.empty(growable: true);
    for (var element in widget.chipTable!.chips) {
      widgetList.add(Container(
        margin: const EdgeInsets.all(AppConstants.chipSpacing),
        child: BingoChip(
          chip: element,
          enabled: widget.playing && !completed,
          playing: widget.playing,
          onDelete: () {
            setState(() {});
          },
          onDone: () {
            Provider.of<CurrentChipTableStatus>(context, listen: false)
                    .setCompletionPercentage =
                widget.chipTable!.completionPercentage;
            Provider.of<CurrentChipTableStatus>(context, listen: false)
                .setIsCompleted = widget.chipTable!.isCompleted;
          },
        ),
      ));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Column(
                  spacing: AppConstants.chipSpacing,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: chipsTableWidget(widget.chipTable?.isCompleted ?? false))));
    });
  }
}
