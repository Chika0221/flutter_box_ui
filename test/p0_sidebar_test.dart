import 'package:box_ui/box_ui.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
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
