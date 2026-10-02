import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/state/current_chip_table_status.dart';
import 'package:bingo_it_all/widgets/chip_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('renders one chip widget for each table item', (tester) async {
    final table = ChipTableModel.empty()
      ..addChip('First')
      ..addChip('Second');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ChipTable(chipTable: table)),
      ),
    );

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('tapping chips updates completion status', (tester) async {
    final table = ChipTableModel.empty()
      ..addChip('First')
      ..addChip('Second');
    final status = CurrentChipTableStatus(table);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: status,
        child: MaterialApp(
          home: Scaffold(body: ChipTable(chipTable: table)),
        ),
      ),
    );

    await tester.tap(find.text('First'));
    await tester.pump();

    expect(table.completedChips, 1);
    expect(status.completionPercentage, '50.00%');
    expect(status.isCompleted, isFalse);

    await tester.tap(find.text('Second'));
    await tester.pump();

    expect(table.completedChips, 2);
    expect(status.completionPercentage, '100.00%');
    expect(status.isCompleted, isTrue);
  });

  testWidgets('does not toggle chips when not playing', (tester) async {
    final table = ChipTableModel.empty()..addChip('First');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChipTable(chipTable: table, playing: false),
        ),
      ),
    );

    await tester.tap(find.text('First'));
    await tester.pump();

    expect(table.chips.single.done, isFalse);
  });
}
