import 'package:bingo_it/models/chip.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/widgets/bingo_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BingoChip - renders correctly', (WidgetTester tester) async {
    final chipTable = ChipTableModel.empty();
    final chip = ChipModel('Test', chipTable);
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BingoChip(
          chip: chip,
          onDelete: () {},
          onDone: () {},
          enabled: true,
        ),
      ),
    ));

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('BingoChip - toggles on tap when enabled', (WidgetTester tester) async {
    final chipTable = ChipTableModel.empty();
    final chip = ChipModel('Test', chipTable);
    bool onDoneCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BingoChip(
          chip: chip,
          onDelete: () {},
          onDone: () {
            onDoneCalled = true;
          },
          enabled: true,
        ),
      ),
    ));

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(chip.done, true);
    expect(onDoneCalled, true);
  });

  testWidgets('BingoChip - shows delete dialog on long press', (WidgetTester tester) async {
    final chipTable = ChipTableModel.empty();
    final chip = ChipModel('Test', chipTable);
    bool onDeleteCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BingoChip(
          chip: chip,
          onDelete: () {
            onDeleteCalled = true;
          },
          onDone: () {},
          enabled: true,
        ),
      ),
    ));

    await tester.longPress(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    expect(find.text('Sure you want to delete the item?'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(onDeleteCalled, true);
  });
}