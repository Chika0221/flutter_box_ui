import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('keycap shows pending status and read-only blocks clicks', (
    tester,
  ) async {
    var count = 0;
    await tester.pumpWidget(
      host(
        BKeyCap(
          label: 'A',
          description: 'Alpha',
          pending: true,
          readOnly: true,
          onClick: () => count++,
        ),
      ),
    );
    await tester.tap(find.text('A'));
    expect(count, 0);
    expect(find.text('•'), findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);
  });
}
