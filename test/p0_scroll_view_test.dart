import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  home: Align(alignment: Alignment.topLeft, child: child),
);
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
        tester.widget<RawScrollbar>(find.byType(RawScrollbar)).thumbVisibility,
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
  testWidgets('strong scroll view colors its thumb with complementary', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const SizedBox(
          height: 100,
          child: BScrollView(
            emphasis: BEmphasis.strong,
            child: SizedBox(height: 1000),
          ),
        ),
      ),
    );
    expect(
      tester.widget<RawScrollbar>(find.byType(RawScrollbar)).thumbColor,
      BoxThemeData.fallback.complementary,
    );
  });
}
