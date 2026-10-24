import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

Widget host(Widget child) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  home: Align(alignment: Alignment.topLeft, child: child),
);
void main() {
  testWidgets('keycode search and Enter select filtered result', (
    tester,
  ) async {
    BKeycode? selected;
    await tester.pumpWidget(
      host(
        BKeycodePicker(
          keycodes: const [
            BKeycode(code: 'KC_A', name: 'Alpha', category: 'Basic'),
            BKeycode(code: 'KC_B', name: 'Beta', category: 'Basic'),
          ],
          onSelected: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected?.code, 'KC_B');
    await tester.enterText(find.byType(EditableText), 'Beta');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected?.code, 'KC_B');
  });
}
