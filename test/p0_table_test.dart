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
