import 'package:bingo_it/constants/app_constants.dart';
import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/models/chip_table.dart';
import 'package:bingo_it/pages/table_drafts_page.dart';
import 'package:bingo_it/services/table_storage_service.dart';
import 'package:bingo_it/state/current_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CurrentTable currentTable;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    currentTable = CurrentTable();
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider.value(
      value: currentTable,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TableDraftsPage(),
        routes: {
          AppConstants.chipTableRoute: (_) => const Scaffold(
                body: Text('Selected table'),
              ),
        },
      ),
    );
  }

  testWidgets('shows the empty state when no drafts are saved', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Saved Tables'), findsOneWidget);
    expect(find.text('No saved tables yet'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows saved draft name and chip count', (tester) async {
    final table = ChipTableModel.name('Weekend')..addChip('Rain');
    await TableStorageService.saveTable(table);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Table #1: Weekend'), findsOneWidget);
    expect(find.text('Available chips: 1'), findsOneWidget);
  });

  testWidgets('selecting a draft updates the current table and navigates',
      (tester) async {
    final table = ChipTableModel.name('Selected')..addChip('Item');
    await TableStorageService.saveTable(table);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Table #1: Selected'));
    await tester.pumpAndSettle();

    expect(currentTable.currentTable.name, 'Selected');
    expect(find.text('Selected table'), findsOneWidget);
  });

  testWidgets('dismissing a draft deletes it from storage', (tester) async {
    await TableStorageService.saveTable(ChipTableModel.name('To delete'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Table #1: To delete'), findsNothing);
    expect(await TableStorageService.loadSavedTables(), isEmpty);
  });
}
