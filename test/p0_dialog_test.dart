import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('dialog handles confirmation and Escape', (tester) async {
    var confirmed = false;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => BButton(
            label: 'Open',
            onClick: () => BDialog.show<void>(
              context,
              dialog: BDialog(
                title: 'Title',
                onConfirm: () => confirmed = true,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(confirmed, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Content'), findsNothing);
  });
}
