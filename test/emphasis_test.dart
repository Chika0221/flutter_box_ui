import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'strong palette derives contrast, fills and borders from complementary',
    () {
      final t = BoxThemeData(
        accent: const Color(0xFFFF0000),
        background: const Color(0xFFFFFFFF),
      );
      expect(t.emphasized.accent, t.complementary);
      expect(t.emphasized.onAccent, const Color(0xFF000000));
      expect(
        t.emphasized.fillColor,
        Color.lerp(t.background, t.complementary, .15),
      );
      expect(
        t.emphasized.borderColor,
        Color.lerp(t.background, t.complementary, .3),
      );
      expect(t.emphasized.warning, t.warning);
      expect(t.emphasized.error, t.error);
      expect(t.emphasized.success, t.success);
      expect(identical(t.emphasized, t.emphasized), isTrue);
    },
  );
  testWidgets(
    'nested strong scopes do not invert colors and normal resets emphasis',
    (tester) async {
      final t = BoxThemeData.fallback;
      Widget probe(String key) => Builder(
        builder: (context) => ColoredBox(
          key: ValueKey(key),
          color: BoxTheme.emphasizedOf(context).accent,
        ),
      );
      await tester.pumpWidget(
        BoxTheme(
          data: t,
          child: BEmphasisScope(
            emphasis: BEmphasis.strong,
            child: Column(
              children: [
                probe('strong'),
                BEmphasisScope(
                  emphasis: BEmphasis.strong,
                  child: probe('nested'),
                ),
                BEmphasisScope(
                  emphasis: BEmphasis.normal,
                  child: probe('normal'),
                ),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.widget<ColoredBox>(find.byKey(const ValueKey('strong'))).color,
        t.complementary,
      );
      expect(
        tester.widget<ColoredBox>(find.byKey(const ValueKey('nested'))).color,
        t.complementary,
      );
      expect(
        tester.widget<ColoredBox>(find.byKey(const ValueKey('normal'))).color,
        t.accent,
      );
    },
  );
  testWidgets('same child responds to changes in scope and base theme', (
    tester,
  ) async {
    final child = Builder(
      builder: (context) =>
          ColoredBox(color: BoxTheme.emphasizedOf(context).accent),
    );
    Future<void> show(BoxThemeData t, BEmphasis emphasis) => tester.pumpWidget(
      BoxTheme(
        data: t,
        child: BEmphasisScope(emphasis: emphasis, child: child),
      ),
    );
    final first = BoxThemeData.fallback;
    await show(first, BEmphasis.normal);
    expect(
      tester.widget<ColoredBox>(find.byType(ColoredBox)).color,
      first.accent,
    );
    await show(first, BEmphasis.strong);
    expect(
      tester.widget<ColoredBox>(find.byType(ColoredBox)).color,
      first.complementary,
    );
    final next = first.copyWith(accent: const Color(0xFF336699));
    await show(next, BEmphasis.strong);
    expect(
      tester.widget<ColoredBox>(find.byType(ColoredBox)).color,
      next.complementary,
    );
  });
}
