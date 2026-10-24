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
  testWidgets('status includes a symbol and readable label', (tester) async {
    await tester.pumpWidget(
      host(
        const BStatusIndicator(status: BStatus.error, label: 'Disconnected'),
      ),
    );
    expect(find.text('×'), findsOneWidget);
    expect(find.text('Disconnected'), findsOneWidget);
  });
}
