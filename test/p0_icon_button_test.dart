import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
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
  testWidgets('icon button has a square hit region and tooltip', (
    tester,
  ) async {
    var count = 0;
    await tester.pumpWidget(
      host(
        BIconButton(
          icon: const Text('+'),
          tooltip: 'Add',
          onClick: () => count++,
        ),
      ),
    );
    final size = tester.getSize(find.byType(BIconButton));
    expect(size.width, size.height);
    await tester.tap(find.text('+'));
    expect(count, 1);
    expect(
      tester
          .widgetList<Semantics>(find.byType(Semantics))
          .any((s) => s.properties.tooltip == 'Add'),
      isTrue,
    );
  });
  testWidgets('tooltip appears on hover and closes on exit', (tester) async {
    await tester.pumpWidget(
      host(BIconButton(icon: const Text('+'), tooltip: 'Add', onClick: () {})),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(300, 300));
    await mouse.moveTo(tester.getCenter(find.byType(BIconButton)));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('Add'), findsOneWidget);
    await mouse.moveTo(const Offset(300, 300));
    await tester.pumpAndSettle();
    expect(find.text('Add'), findsNothing);
    await mouse.removePointer();
  });
}
