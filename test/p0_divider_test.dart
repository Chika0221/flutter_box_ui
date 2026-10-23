import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('divider supports vertical and horizontal axes', (tester) async {
    await tester.pumpWidget(
      host(
        const Row(
          children: [
            SizedBox(
              height: 100,
              child: BDivider(axis: Axis.vertical, thickness: 2),
            ),
            Expanded(child: BDivider()),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byType(BDivider).first).width, 2);
    expect(tester.getSize(find.byType(BDivider).last).height, 1);
  });
}
