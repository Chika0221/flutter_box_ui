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
  testWidgets('dialog handles confirmation and Escape', (tester) async {
    var confirmed = false;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => BButton(
            label: 'Open',
            onClick: () => BDialog.show<void>(
              context,
              dialog: BDialog(
                title: 'Title',
                onConfirm: () => confirmed = true,
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(confirmed, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Content'), findsNothing);
  });
  testWidgets(
    'dialog preserves base theme and strong scope across route boundaries',
    (tester) async {
      final theme = BoxThemeData.fallback.copyWith(
        accent: const Color(0xFF336699),
      );
      await tester.pumpWidget(
        host(
          BoxTheme(
            data: theme,
            child: BEmphasisScope(
              emphasis: BEmphasis.strong,
              child: Builder(
                builder: (context) => BButton(
                  label: 'Show strong',
                  onClick: () => BDialog.show<void>(
                    context,
                    dialog: const BDialog(
                      title: 'Strong dialog',
                      child: BTextField(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show strong'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).cursorColor,
        theme.complementary,
      );
    },
  );
}
