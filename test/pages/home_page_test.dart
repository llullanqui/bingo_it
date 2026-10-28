import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/l10n/app_localizations.dart';
import 'package:bingo_it_all/pages/home_page.dart';
import 'package:bingo_it_all/state/current_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late CurrentTable currentTable;

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider.value(
      value: currentTable,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        routes: {
          AppConstants.chipTableRoute: (_) =>
              const Scaffold(body: Text('Chip table route')),
          AppConstants.savedTablesRoute: (_) =>
              const Scaffold(body: Text('Saved tables route')),
        },
      ),
    );
  }

  setUp(() {
    currentTable = CurrentTable();
  });

  testWidgets('shows all bingo options', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Bingo it all!'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(4));
    expect(find.text('Classic 75 Bingo'), findsOneWidget);
    expect(find.text('Classic 90 Bingo'), findsOneWidget);
    expect(find.text('Custom Bingo'), findsOneWidget);
    expect(find.text('Saved Bingos'), findsOneWidget);
  });

  testWidgets('creates a custom table and navigates to it', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Custom Bingo'));
    await tester.pumpAndSettle();

    expect(find.text('Chip table route'), findsOneWidget);
    expect(currentTable.currentTable.chips, isEmpty);
    expect(currentTable.currentTable.name, isNull);
  });

  testWidgets('generates a 75-ball table and navigates to it', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Classic 75 Bingo'));
    await tester.pumpAndSettle();

    final table = currentTable.currentTable;
    expect(find.text('Chip table route'), findsOneWidget);
    expect(table.name, 'Classic Bingo');
    expect(table.chips, hasLength(25));
    expect(table.columns.map((column) => column.name),
        AppConstants.classicBingo75Columns);
  });

  testWidgets('generates a 90-ball table and navigates to it', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Classic 90 Bingo'));
    await tester.pumpAndSettle();

    final table = currentTable.currentTable;
    expect(find.text('Chip table route'), findsOneWidget);
    expect(table.name, 'Classic Bingo');
    expect(table.chips, hasLength(27));
    expect(table.columns.map((column) => column.name),
        AppConstants.classicBingo90Columns);
  });

  testWidgets('navigates to saved tables', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Saved Bingos'));
    await tester.pumpAndSettle();

    expect(find.text('Saved tables route'), findsOneWidget);
  });
}
