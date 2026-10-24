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
  testWidgets('text field edits, submits, and displays error', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      host(
        BTextField(
          placeholder: 'Name',
          errorText: 'Required',
          onSubmitted: (v) => submitted = v,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Profile');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'Profile');
    expect(find.text('Required'), findsOneWidget);
  });
  testWidgets('strong field applies complementary to its cursor and fill', (
    tester,
  ) async {
    await tester.pumpWidget(host(const BTextField(emphasis: BEmphasis.strong)));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).cursorColor,
      BoxThemeData.fallback.complementary,
    );
    final containers = tester.widgetList<Container>(
      find.descendant(
        of: find.byType(BTextField),
        matching: find.byType(Container),
      ),
    );
    expect(
      containers.any(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration! as BoxDecoration).color ==
                BoxThemeData.fallback.emphasized.fillColor,
      ),
      isTrue,
    );
  });
  testWidgets('external controller updates placeholder and survives unmount', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    await tester.pumpWidget(
      host(
        BTextField(
          controller: controller,
          focusNode: focus,
          placeholder: 'Name',
        ),
      ),
    );
    expect(find.text('Name'), findsOneWidget);
    controller.text = 'Updated';
    await tester.pump();
    expect(find.text('Name'), findsNothing);
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    await tester.pumpWidget(host(const SizedBox()));
    controller.clear();
    controller.dispose();
    focus.dispose();
  });

  testWidgets('disabled field cannot receive focus or edit text', (
    tester,
  ) async {
    final focus = FocusNode();
    await tester.pumpWidget(host(BTextField(enabled: false, focusNode: focus)));
    await tester.tap(find.byType(BTextField));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
    await tester.pumpWidget(host(const SizedBox()));
    focus.dispose();
  });
}
