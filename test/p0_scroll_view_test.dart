import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets(
    'scroll view owns a visible scrollbar and supports wheel scrolling',
    (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(
        host(
          SizedBox(
            height: 100,
            child: BScrollView(
              controller: controller,
              child: const SizedBox(height: 1000, child: Text('Long')),
            ),
          ),
        ),
      );
      expect(
        tester.widget<Scrollbar>(find.byType(Scrollbar)).thumbVisibility,
        true,
      );
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -80),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
      await tester.pumpWidget(host(const SizedBox()));
      controller.dispose();
    },
  );
}
