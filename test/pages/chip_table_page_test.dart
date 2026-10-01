import 'package:bingo_it/enums/chip_table_page_status.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/models/chip.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/pages/chip_table_page.dart';
import 'package:bingo_it/state/current_chip_table_status.dart';
import 'package:bingo_it/state/current_table.dart';
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
      filledMockTable = ChipTableModel([
        ...List.generate(
            10, (index) => ChipModel('Item ${index + 1}', mockTable))
      ]);
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

    testWidgets('Shows error when trying to start with less than 5 items',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Add at least 5 items'), findsOneWidget);
    });

    testWidgets('Changes state when trying to start with more than 5 items',
        (tester) async {
      await tester.pumpWidget(createFilledWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Let's go!"));
      await tester.pumpAndSettle();

      expect(find.text('Add at least 5 items'), findsNothing);
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
