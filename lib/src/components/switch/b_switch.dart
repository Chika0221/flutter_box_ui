import 'package:box_ui/src/theme/box_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BSwitch extends HookConsumerWidget {
  const BSwitch({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      width: 64,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: [
            Align(
              alignment: .center,
              child: Container(
                height: 12,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: .circular(24),
                  color: boxTheme.fillColor,
                ),
              ),
            ),
            Padding(
              padding: .fromLTRB(0, 0, 10, 0),
              child: Container(
                height: 32,
                width: 32,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: boxTheme.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
