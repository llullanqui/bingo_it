import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/state/current_chip_table_status.dart';
import 'package:flutter/material.dart';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/widgets/bingo_chip.dart';
import 'package:provider/provider.dart';

class ChipTable extends StatefulWidget {
  final ChipTableModel? chipTable;
  final bool playing;
  final Function? onCompletionChanged;

  const ChipTable({
    super.key,
    this.chipTable,
    this.onCompletionChanged,
    this.playing = true,
  });

  @override
  State<ChipTable> createState() => _ChipTableState();
}

class _ChipTableState extends State<ChipTable> {
  List<Widget> chipsTableWidget(bool completed) {
    List<Widget> widgetList = List.empty(growable: true);
    if (widget.chipTable?.chips == null || widget.chipTable!.chips.isEmpty) {
      widgetList.add(
        Container(
          margin: const EdgeInsets.all(AppConstants.chipSpacing),
          child: Text(
            AppLocalizations.of(context).noChipsYet,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
      return widgetList;
    }

    if (widget.chipTable!.displayColumns()) {
      widgetList.addAll(
        widget.chipTable!.tableColumns.map((column) {
          return Center(
            child: Text(
              column.displayedName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }).toList(),
      );
    }

    for (var element in widget.chipTable!.chips) {
      widgetList.add(
        BingoChip(
          chip: element,
          enabled: widget.playing && !completed,
          playing: widget.playing,
          onDelete: () {
            setState(() {});
          },
          onDone: () {
            Provider.of<CurrentChipTableStatus>(
              context,
              listen: false,
            ).setCompletionPercentage = widget.chipTable!.completionPercentage;
            Provider.of<CurrentChipTableStatus>(
              context,
              listen: false,
            ).setIsCompleted = widget.chipTable!.isCompleted;
          },
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: widget.chipTable!.chipsAmount > 0
              ? GridBuilder(
                  columns: widget.chipTable!.tableColumns.isNotEmpty
                      ? widget.chipTable!.tableColumns.length
                      : AppConstants.defaultColumnsAmount,
                  children: chipsTableWidget(
                    widget.chipTable?.isCompleted ?? false,
                  ),
                )
              : const EmptyChipTable(),
        );
      },
    );
  }
}

class EmptyChipTable extends StatelessWidget {
  const EmptyChipTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).noChipsYet,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class GridBuilder extends StatelessWidget {
  final int columns;
  final List<Widget> children;

  const GridBuilder({super.key, required this.columns, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: GridView.count(
        crossAxisCount: columns,
        childAspectRatio: 1.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppConstants.chipSpacing,
        crossAxisSpacing: AppConstants.chipSpacing,
        padding: const EdgeInsets.all(AppConstants.chipSpacing),
        children: children,
      ),
    );
  }
}
