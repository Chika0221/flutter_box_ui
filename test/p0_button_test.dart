import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
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
    'button activates with keyboard and ignores activation when disabled',
    (tester) async {
      var count = 0;
      await tester.pumpWidget(
        host(BButton(label: 'Apply', onClick: () => count++)),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(count, 1);
      await tester.pumpWidget(host(const BButton(label: 'Apply')));
      await tester.tap(find.text('Apply'));
      expect(count, 1);
    },
  );
  testWidgets(
    'strong button uses complementary with readable text and normal overrides scope',
    (tester) async {
      final t = BoxThemeData.fallback;
      await tester.pumpWidget(
        host(
          BoxTheme(
            data: t,
            child: BEmphasisScope(
              emphasis: BEmphasis.strong,
              child: Column(
                children: [
                  BButton(label: 'Strong', onClick: () {}),
                  BButton(
                    label: 'Normal',
                    emphasis: BEmphasis.normal,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      for (final (label, color, onColor) in [
        ('Strong', t.complementary, t.emphasized.onAccent),
        ('Normal', t.accent, t.onAccent),
      ]) {
        final button = find.ancestor(
          of: find.text(label),
          matching: find.byType(BButton),
        );
        final colors = tester
            .widgetList<Container>(
              find.descendant(of: button, matching: find.byType(Container)),
            )
            .map((c) => c.decoration)
            .whereType<BoxDecoration>()
            .map((d) => d.color);
        expect(colors, contains(color));
        expect(tester.widget<Text>(find.text(label)).style!.color, onColor);
      }
    },
  );
  testWidgets(
    'strong secondary and ghost buttons emphasize text without changing variant',
    (tester) async {
      await tester.pumpWidget(
        host(
          Column(
            children: [
              for (final variant in [
                BButtonVariant.secondary,
                BButtonVariant.ghost,
              ])
                BButton(
                  label: variant.name,
                  variant: variant,
                  emphasis: BEmphasis.strong,
                  onClick: () {},
                ),
            ],
          ),
        ),
      );
      for (final label in ['secondary', 'ghost']) {
        expect(
          tester.widget<Text>(find.text(label)).style!.color,
          BoxThemeData.fallback.complementary,
        );
      }
    },
  );
}
