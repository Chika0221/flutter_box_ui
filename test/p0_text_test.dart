import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('text uses theme typography', (tester) async {
    await tester.pumpWidget(
      host(const BText('Heading', variant: BTextStyle.heading)),
    );
    expect(tester.widget<Text>(find.text('Heading')).style!.fontSize, 20);
  });
}
