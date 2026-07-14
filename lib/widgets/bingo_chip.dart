import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/models/chip.dart';
import 'package:flutter/material.dart';

class BingoChip extends StatefulWidget {
  const BingoChip({
    super.key,
    required this.chip,
    required this.onDelete,
    required this.onDone,
    required this.enabled,
  });

  final ChipModel chip;
  final Function onDelete;
  final Function onDone;
  final bool enabled;

  @override
  State<BingoChip> createState() => _BingoChipState();
}

class _BingoChipState extends State<BingoChip> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.chipBorderRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 2
        )
      ),
      clipBehavior: Clip.antiAlias,
      color: widget.chip.done
        ? Colors.green
        : Theme.of(context).colorScheme.onPrimary,
      child: InkWell(
          onTap: widget.enabled
              ? () {
                  setState(() { 
                    widget.chip.toggle();
                  });
                  widget.onDone();
                }
              : () {},
          onLongPress: widget.enabled
            ? () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).deleteItem),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context).no)),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              widget.chip.takeAwayFromTable();
                            });
                            widget.onDelete();
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context).yes)),
                    ],
                  );
                });
            }
            : () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppConstants.chipVerticalPadding,
              horizontal: AppConstants.chipHorizontalPadding,
            ),
            child: Text(widget.chip.text,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
