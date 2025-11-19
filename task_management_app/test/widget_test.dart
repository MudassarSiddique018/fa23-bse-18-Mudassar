import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // FIX: remove const
    await tester.pumpWidget(MyApp());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
