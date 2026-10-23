import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets(
    'layout handles negative coordinates, rotation and read-only keys',
    (tester) async {
      String? selected;
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 300,
            child: BKeyboardLayout(
              keys: const [
                BKeyGeometry(id: 'a', label: 'A', x: -1, y: -1, rotation: .5),
                BKeyGeometry(id: 'b', label: 'B', x: 1, y: 0, readOnly: true),
              ],
              onSelected: (v) => selected = v,
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(selected, 'a');
      await tester.tap(find.text('B'));
      expect(selected, 'a');
      expect(tester.takeException(), isNull);
    },
  );
}
