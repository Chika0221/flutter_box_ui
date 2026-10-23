import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets(
    'button activates with keyboard and ignores activation when disabled',
    (tester) async {
      var count = 0;
      await tester.pumpWidget(
        host(BButton(label: 'Apply', onClick: () => count++)),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(count, 1);
      await tester.pumpWidget(host(const BButton(label: 'Apply')));
      await tester.tap(find.text('Apply'));
      expect(count, 1);
    },
  );
}
