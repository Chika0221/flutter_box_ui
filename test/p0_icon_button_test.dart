import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('icon button has a square hit region and tooltip', (
    tester,
  ) async {
    var count = 0;
    await tester.pumpWidget(
      host(
        BIconButton(
          icon: const Text('+'),
          tooltip: 'Add',
          onClick: () => count++,
        ),
      ),
    );
    final size = tester.getSize(find.byType(BIconButton));
    expect(size.width, size.height);
    await tester.tap(find.text('+'));
    expect(count, 1);
    expect(find.byTooltip('Add'), findsOneWidget);
  });
}
