import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:individualproject/navigation.dart';
import 'package:individualproject/screens/query.dart';
import 'package:individualproject/screens/record.dart';

void main() {
  testWidgets('Navigation should display Record by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Navigation(),
      ),
    );

    expect(find.text('Record'), findsOneWidget);
  });

  testWidgets('Query Screen should display UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: QueryScreen(),
      ),
    );

    expect(find.text('Query'), findsOneWidget);
  });

  testWidgets('Record Screen should display UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RecordScreen(),
      ),
    );

    expect(find.text('Date'), findsOneWidget);
  });
}
