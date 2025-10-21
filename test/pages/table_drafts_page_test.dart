import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bingo_it/pages/table_drafts_page.dart';

void main() {
  testWidgets('shows AppBar title and loading indicator initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TableDraftsPage()));

    expect(find.text('Saved Tables'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not show empty state while loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TableDraftsPage()));

    expect(find.text('No saved tables yet'), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}