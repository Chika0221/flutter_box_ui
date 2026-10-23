import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
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
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();
    expect(selected, 'b');
  });
}
