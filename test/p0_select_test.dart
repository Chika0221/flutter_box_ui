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
  testWidgets('select opens overlay and reports selection', (tester) async {
    String? selected;
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 240,
          child: BSelect<String>(
            placeholder: 'Choose',
            options: const [
              BSelectOption(value: 'a', label: 'Alpha'),
              BSelectOption(value: 'b', label: 'Beta'),
            ],
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();
    expect(selected, 'b');
  });
  testWidgets('strong select applies complementary to its palette', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        BSelect<String>(
          emphasis: BEmphasis.strong,
          options: const [BSelectOption(value: 'a', label: 'Alpha')],
          onChanged: (_) {},
        ),
      ),
    );
    expect(
      BoxTheme.emphasizedOf(tester.element(find.text('▾'))).accent,
      BoxThemeData.fallback.complementary,
    );
  });
  testWidgets('keyboard navigation scrolls long menus and Escape cancels', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 240,
          child: BSelect<int>(
            placeholder: 'Choose',
            options: List.generate(
              30,
              (i) => BSelectOption(value: i, label: 'Option $i'),
            ),
            onChanged: (v) => selected = v,
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    for (var i = 0; i < 20; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
    }
    expect(find.text('Option 20').hitTestable(), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, 20);
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Option 0'), findsNothing);
    expect(selected, 20);
  });

  testWidgets('disabled select does not open its menu', (tester) async {
    await tester.pumpWidget(
      host(
        const BSelect<String>(
          placeholder: 'Choose',
          options: [BSelectOption(value: 'a', label: 'Alpha')],
        ),
      ),
    );
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsNothing);
  });
}
