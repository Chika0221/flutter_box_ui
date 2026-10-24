import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('checkbox label and Space activate the same controlled value', (
    tester,
  ) async {
    var value = false;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => BCheckBox(
            value: value,
            label: 'Enabled',
            onClick: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Enabled'));
    await tester.pump();
    expect(value, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(value, isFalse);
  });
}
