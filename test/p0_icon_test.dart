import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets(
    'icon default size follows theme and explicit size overrides it',
    (tester) async {
      await tester.pumpWidget(
        host(
          BoxTheme(
            data: BoxThemeData.fallback.copyWith(iconSize: 36),
            child: const Row(
              children: [
                BIcon(icon: BoxIcons.check),
                BIcon(icon: BoxIcons.check, size: BIconSize.ss),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(BIcon).first).width, 36);
      expect(tester.getSize(find.byType(BIcon).last).width, 24);
    },
  );
}
