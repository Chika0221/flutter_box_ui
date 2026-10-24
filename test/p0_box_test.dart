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
  testWidgets('box derives background and border from theme', (tester) async {
    final theme = BoxThemeData(
      accent: const Color(0xFF336699),
      background: const Color(0xFFFFFFFF),
    );
    await tester.pumpWidget(
      host(
        BoxTheme(
          data: theme,
          child: const BBox(child: Text('Box')),
        ),
      ),
    );
    final container = tester.widget<Container>(
      find
          .descendant(of: find.byType(BBox), matching: find.byType(Container))
          .first,
    );
    expect((container.decoration! as BoxDecoration).color, theme.fillColor);
  });
}
