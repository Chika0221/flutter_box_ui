import 'dart:convert';

import 'package:flutter/services.dart';
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
  testWidgets(
    'icon default size follows theme and explicit size overrides it',
    (tester) async {
      await tester.pumpWidget(
        host(
          BoxTheme(
            data: BoxThemeData.fallback.copyWith(iconSize: 36),
            child: const Row(
              children: [
                BIcon(icon: BoxIcons.check),
                BIcon(icon: BoxIcons.check, size: BIconSize.ss),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(BIcon).first).width, 36);
      expect(tester.getSize(find.byType(BIcon).last).width, 24);
    },
  );
  testWidgets(
    'strong icon uses complementary and explicit foreground still wins',
    (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
            'flutter/assets',
            (_) async => ByteData.sublistView(
              Uint8List.fromList(
                utf8.encode(
                  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><rect width="24" height="24" fill="#000000"/></svg>',
                ),
              ),
            ),
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', null),
      );
      await tester.pumpWidget(
        host(
          const Row(
            children: [
              BIcon(icon: 'emphasis-test.svg', emphasis: BEmphasis.strong),
              BIcon(
                icon: 'emphasis-test.svg',
                emphasis: BEmphasis.strong,
                foregroundColor: Color(0xFF123456),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final futures = tester
          .widgetList<FutureBuilder<String>>(find.byType(FutureBuilder<String>))
          .toList();
      final color = BoxThemeData.fallback.complementary;
      await tester.runAsync(() async {
        expect(
          await futures[0].future,
          contains(
            'rgb(${(color.r * 255).round()}, ${(color.g * 255).round()}, ${(color.b * 255).round()})',
          ),
        );
        expect(await futures[1].future, contains('rgb(18, 52, 86)'));
      });
    },
  );
}
