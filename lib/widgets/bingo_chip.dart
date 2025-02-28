import 'package:flutter/material.dart';

class BingoChip extends StatefulWidget {
  const BingoChip({
    super.key,
    required this.text,
    required this.container,
    required this.onDelete,
    required this.onDone,
  });

  final String text;
  final List<Widget> container;
  final Function onDelete;
  final Function onDone;

  @override
  State<BingoChip> createState() => _BingoChipState();
}

class _BingoChipState extends State<BingoChip> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 40,
        backgroundColor:
            done ? Colors.green : Theme.of(context).colorScheme.onPrimary,
        child: Text(widget.text),
      ),
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Select an option"),
                actions: [
                  TextButton(
                      onPressed: () {
                        widget.onDelete();
                        widget.container.remove(widget);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          done = true;
                        });
                        widget.onDone();
                        Navigator.pop(context);
                      },
                      child: const Text('Done!')),
                ],
              );
            });
      },
    );
  }
}
