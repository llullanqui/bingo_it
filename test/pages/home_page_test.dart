import 'package:bingo_it/l10n/app_localizations.dart';
import 'package:bingo_it/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage has title and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    // Verify title exists
    expect(find.byType(Text), findsNWidgets(3));

    // Verify buttons exist
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    // Test navigation buttons
    final newTableButton = find.widgetWithText(ElevatedButton, 'New Table');
    final savedTablesButton = find.widgetWithText(ElevatedButton, 'Saved Tables');

    expect(newTableButton, findsOneWidget);
    expect(savedTablesButton, findsOneWidget);
  });
}