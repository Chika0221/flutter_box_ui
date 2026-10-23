import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final first = BoxThemeData(
    accent: const Color(0xFFFF0000),
    background: const Color(0xFFFFFFFF),
    primaryFontFamily: 'Roboto',
  );

  test('copyWithで派生色を再計算して元のデータを保持する', () {
    final next = first.copyWith(
      accent: const Color(0xFF000000),
      background: const Color(0xFF000000),
      primaryFontFamily: () => null,
    );
    expect(first.accent, const Color(0xFFFF0000));
    expect(first.primaryFontFamily, 'Roboto');
    expect(next.primaryFontFamily, isNull);
    expect(next.fillColor, const Color(0xFF000000));
    expect(next.onAccent, const Color(0xFFFFFFFF));
    expect(next.primaryTextStyle.color, const Color(0xFFFFFFFF));
    expect(first.copyWith().primaryFontFamily, 'Roboto');
  });

  testWidgets('テーマ未指定ならデフォルトを取得する', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          expect(BoxTheme.maybeOf(context), isNull);
          expect(BoxTheme.of(context), same(BoxThemeData.fallback));
          return const SizedBox();
        },
      ),
    );
  });

  testWidgets('入れ子のテーマを優先し外側のテーマも保持する', (tester) async {
    final inner = first.copyWith(accent: const Color(0xFF0000FF));
    await tester.pumpWidget(
      BoxTheme(
        data: first,
        child: Builder(
          builder: (context) {
            expect(BoxTheme.of(context), same(first));
            return BoxTheme(
              data: inner,
              child: Builder(
                builder: (context) {
                  expect(BoxTheme.of(context), same(inner));
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  });

  testWidgets('同じ子Widgetでもテーマを差し替えると表示が更新される', (tester) async {
    const child = BSwitch(value: true, onChanged: null);
    Widget wrap(BoxThemeData data) => Directionality(
      textDirection: TextDirection.ltr,
      child: BoxTheme(
        data: data,
        child: const Center(child: child),
      ),
    );
    Color? trackColor() =>
        (tester.widget<Container>(find.byType(Container).first).decoration!
                as BoxDecoration)
            .color;

    await tester.pumpWidget(wrap(first));
    expect(trackColor(), first.accent);
    final next = first.copyWith(accent: const Color(0xFF0000FF));
    await tester.pumpWidget(wrap(next));
    expect(trackColor(), next.accent);
  });
}
