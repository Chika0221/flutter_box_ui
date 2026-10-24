import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('status includes a symbol and readable label', (tester) async {
    await tester.pumpWidget(
      host(
        const BStatusIndicator(status: BStatus.error, label: 'Disconnected'),
      ),
    );
    expect(find.text('×'), findsOneWidget);
    expect(find.text('Disconnected'), findsOneWidget);
  });
}
