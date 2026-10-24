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
  testWidgets('sidebar selects items and collapses', (tester) async {
    int? selected;
    await tester.pumpWidget(
      host(
        SideBar(
          items: const [
            BSidebarItem(label: 'Home', icon: Text('H')),
            BSidebarItem(label: 'Settings', icon: Text('S')),
          ],
          onSelected: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.text('Settings'));
    expect(selected, 1);
    await tester.tap(find.text('☰'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(SideBar)).width, 56);
  });
}
