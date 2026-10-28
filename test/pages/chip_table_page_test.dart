import 'package:bingo_it_all/enums/chip_table_page_status.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/pages/chip_table_page.dart';
import 'package:bingo_it_all/services/table_handlers/table_handler_service.dart';
import 'package:bingo_it_all/state/current_chip_table_status.dart';
import 'package:bingo_it_all/state/current_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ChipTableModel mockTable;
  late ChipTableModel filledMockTable;

  group("ChipTablePage", () {
    setUp(() {
      mockTable = ChipTableModel.empty();
      filledMockTable = ChipTableModel.empty();
      for (var index = 0; index < 10; index++) {
        filledMockTable.addChip('Item ${index + 1}');
      }
      SharedPreferences.setMockInitialValues({});
    });

    Widget createWidgetUnderTest() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentTable>(
            create: (context) => CurrentTable()..currentTable = mockTable,
          ),
          ChangeNotifierProvider<CurrentChipTableStatus>(
            create: (context) => CurrentChipTableStatus(
              Provider.of<CurrentTable>(context, listen: false).currentTable,
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChipTablePage(),
        ),
      );
    }

    Widget createFilledWidgetUnderTest() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentTable>(
            create: (context) => CurrentTable()..currentTable = filledMockTable,
          ),
          ChangeNotifierProvider<CurrentChipTableStatus>(
            create: (context) => CurrentChipTableStatus(
              Provider.of<CurrentTable>(context, listen: false).currentTable,
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChipTablePage(),
        ),
      );
    }

    testWidgets('ChipTablePage shows empty state initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(FloatingActionButton), findsNWidgets(3));
      expect(find.byIcon(Icons.star_rate_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('Can add chips to table', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Test Item');
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle();

      expect(find.text('Test Item'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('validates empty chip text and allows cancelling',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter some text'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(mockTable.chips, isEmpty);
    });

    testWidgets('cannot save a table with fewer than five chips',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.text('Add at least 5 chips'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Shows error when trying to start with less than 5 items',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Add at least 5 chips'), findsOneWidget);
    });

    testWidgets('does not start when the start confirmation is declined',
        (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(
        tester.state<ChipTablePageState>(find.byType(ChipTablePage)).pageStatus,
        ChipTablePageStatus.setup,
      );
      expect(find.text('Ready to start?'), findsNothing);
    });

    testWidgets('Changes state when trying to start with more than 5 items',
        (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Let's go!"));
      await tester.pumpAndSettle();

      expect(find.text('Add at least 5 chips'), findsNothing);
      expect(
          tester
              .state<ChipTablePageState>(find.byType(ChipTablePage))
              .pageStatus,
          ChipTablePageStatus.playing);
    });

    testWidgets('Can save table', (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Saved table');
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Table saved successfully!'), findsOneWidget);
    });

    testWidgets('can cancel saving a table without persisting it',
        (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Cancelled table');
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(filledMockTable.name, isNull);
      expect(await TableHandlerService().getSavedTables(), isEmpty);
    });

    testWidgets('marks chips complete and shows the winning state',
        (tester) async {
      final table = ChipTableModel.empty();
      for (var index = 0; index < 5; index++) {
        table.addChip('Chip ${index + 1}');
      }
      filledMockTable = table;
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Let's go!"));
      await tester.pumpAndSettle();

      for (var index = 1; index <= 5; index++) {
        await tester.tap(find.text('Chip $index'));
        await tester.pump();
      }

      expect(find.text('100.00%'), findsOneWidget);
      expect(find.text('YOU WIN!'), findsOneWidget);
      expect(
        tester.state<ChipTablePageState>(find.byType(ChipTablePage)).pageStatus,
        ChipTablePageStatus.completed,
      );
    });

    testWidgets('can remove a chip from the table after confirmation',
        (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.longPress(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(find.text('Sure you want to delete the chip?'), findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsNothing);
      expect(filledMockTable.chipsAmount, 9);
    });

    testWidgets('Can restart table', (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      // Start game
      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Let's go!"));
      await tester.pumpAndSettle();

      // Verify restart button appears
      expect(find.byIcon(Icons.restart_alt), findsOneWidget);

      // Tap restart
      await tester.tap(find.byIcon(Icons.restart_alt));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.restart_alt), findsNothing);
    });
  });
}
