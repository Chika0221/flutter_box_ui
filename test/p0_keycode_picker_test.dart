import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('keycode search and Enter select filtered result', (
    tester,
  ) async {
    BKeycode? selected;
    await tester.pumpWidget(
      host(
        BKeycodePicker(
          keycodes: const [
            BKeycode(code: 'KC_A', name: 'Alpha', category: 'Basic'),
            BKeycode(code: 'KC_B', name: 'Beta', category: 'Basic'),
          ],
          onSelected: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected?.code, 'KC_B');
    await tester.enterText(find.byType(TextField), 'Beta');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected?.code, 'KC_B');
  });
}
