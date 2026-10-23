import 'package:box_ui/box_ui.dart';
// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
void main() {
  testWidgets('table retains header while rows scroll and selects a row', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      host(
        SizedBox(
          height: 180,
          width: 300,
          child: BTable(
            columns: const [BTableColumn(label: 'Header')],
            rows: List.generate(30, (i) => [Text('Row $i')]),
            onRowSelected: (v) => selected = v,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Row 0'));
    expect(selected, 0);
    final headerPosition = tester.getTopLeft(find.text('Header'));
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Header')), headerPosition);
    expect(tester.takeException(), isNull);
  });
}
