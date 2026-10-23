import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('bay map reports the clicked position and displays empty bays', (
    tester,
  ) async {
    BBay? selected;
    await tester.pumpWidget(
      host(
        BBayMap(
          modules: const {BBay.frontLeft: 'Knob'},
          onSelected: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.text('手前 L\nKnob'));
    expect(selected, BBay.frontLeft);
    expect(find.text('外側 R\n空き'), findsOneWidget);
  });
}
