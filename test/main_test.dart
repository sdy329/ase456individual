import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:individualproject/navigation.dart';
import 'package:individualproject/screens/query.dart';
import 'package:individualproject/screens/record.dart';
import 'package:individualproject/screens/report.dart';

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
    expect(find.text('From'), findsOneWidget);
    expect(find.text('Task'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    expect(find.text('Tag'), findsOneWidget);
  });

  testWidgets('Report Screen should display UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReportScreen(),
      ),
    );

    expect(find.text('Start Date'), findsOneWidget);
    expect(find.text('End Date'), findsOneWidget);
  });

  testWidgets('Navigation drawer should navigate to Query Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Navigation(),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.tap(find.byIcon(Icons.search), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Query'), findsOneWidget);
  });

  testWidgets('Navigation drawer should navigate to Report Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Navigation(),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.tap(find.byIcon(Icons.view_timeline_outlined),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Report'), findsOneWidget);
  });

  testWidgets('Navigation drawer should navigate to Priority Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Navigation(),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.tap(find.byIcon(Icons.timer_outlined), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Priority'), findsOneWidget);
  });
}
