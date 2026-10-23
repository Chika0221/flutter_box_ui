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
  testWidgets(
    'strong keycap changes selection but keeps pending warning semantic',
    (tester) async {
      await tester.pumpWidget(
        host(
          BKeyCap(
            label: 'Key',
            selected: true,
            pending: true,
            emphasis: BEmphasis.strong,
            onClick: () {},
          ),
        ),
      );
      final decorations = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(BKeyCap),
              matching: find.byType(Container),
            ),
          )
          .map((c) => c.decoration)
          .whereType<BoxDecoration>();
      expect(
        decorations.any(
          (d) => d.color == BoxThemeData.fallback.emphasized.fillColor,
        ),
        isTrue,
      );
      expect(
        tester.widget<Text>(find.text('•')).style!.color,
        BoxThemeData.fallback.warning,
      );
    },
  );
}
