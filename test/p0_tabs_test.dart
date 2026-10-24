import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ctrl+Tab and digits select tabs', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => StatefulBuilder(
            builder: (context, setState) => BTabs(
              labels: const ['One', 'Two'],
              selectedIndex: selected,
              onSelected: (v) => setState(() => selected = v),
            ),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(selected, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    expect(selected, 0);
  });
}
