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
  testWidgets('text uses theme typography', (tester) async {
    await tester.pumpWidget(
      host(const BText('Heading', variant: BTextStyle.heading)),
    );
    expect(tester.widget<Text>(find.text('Heading')).style!.fontSize, 20);
  });
  testWidgets(
    'strong text uses complementary while default text keeps foreground',
    (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              BText('Strong', emphasis: BEmphasis.strong),
              BText('Normal'),
            ],
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('Strong')).style!.color,
        BoxThemeData.fallback.complementary,
      );
      expect(
        tester.widget<Text>(find.text('Normal')).style!.color,
        BoxThemeData.fallback.foreground,
      );
    },
  );
}
