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
  testWidgets('bay map reports the clicked position and displays empty bays', (
    tester,
  ) async {
    BBay? selected;
    await tester.pumpWidget(
      host(
        BBayMap(
          modules: const {BBay.frontLeft: 'Knob'},
          onSelected: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.text('手前 L\nKnob'));
    expect(selected, BBay.frontLeft);
    expect(find.text('外側 R\n空き'), findsOneWidget);
  });
}
