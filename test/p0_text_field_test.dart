import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
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
    await tester.enterText(find.byType(TextField), 'Profile');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'Profile');
    expect(find.text('Required'), findsOneWidget);
  });
  testWidgets('strong field applies complementary to Material primary color', (
    tester,
  ) async {
    await tester.pumpWidget(host(const BTextField(emphasis: BEmphasis.strong)));
    final context = tester.element(find.byType(TextField));
    expect(
      Theme.of(context).colorScheme.primary,
      BoxThemeData.fallback.complementary,
    );
    expect(
      Theme.of(context).inputDecorationTheme.fillColor,
      BoxThemeData.fallback.emphasized.fillColor,
    );
  });
}
