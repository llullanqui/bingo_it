import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:flutter/material.dart';

class ChipTable extends StatefulWidget {
  const ChipTable({super.key});

  @override
  State<ChipTable> createState() => _ChipTableState();
}

class _ChipTableState extends State<ChipTable> {

  final List<Widget> _items = [];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget _bingoChip(String text) {
    BingoChip chip = BingoChip(
      text: text,
      container: _items,
      onDelete: () {
        setState(() {});
      },
      onDone: () {
        setState(() {});
      },
    );

    return chip;
  }
  
}