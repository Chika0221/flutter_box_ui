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
  testWidgets('divider supports vertical and horizontal axes', (tester) async {
    await tester.pumpWidget(
      host(
        const Row(
          children: [
            SizedBox(
              height: 100,
              child: BDivider(axis: Axis.vertical, thickness: 2),
            ),
            Expanded(child: BDivider()),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byType(BDivider).first).width, 2);
    expect(tester.getSize(find.byType(BDivider).last).height, 1);
  });
}
