import 'package:box_ui/src/theme/box_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BSlider extends HookConsumerWidget {
  const BSlider({
    super.key,
    this.labelBuilder,
    required this.max,
    required this.min,
    required this.value,
    required this.interval,
  });

  final String Function(double value)? labelBuilder;
  final double max;
  final double min;
  final double value;
  final double interval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int divisions = (max / interval).toInt() + 1;

    final isDrag = useState(false);
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: .center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                curve: Curves.decelerate,
                height: (isDrag.value) ? 32 : 8,
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: boxTheme.accent,
                ),
                padding: .symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: List.generate(divisions, (index) {
                      return Container(
                        width: 4,
                        decoration: ShapeDecoration(
                          shape: StadiumBorder(),
                          color: boxTheme.background,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                isDrag.value = true;
              },
              onHorizontalDragEnd: (details) {
                isDrag.value = false;
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 32,
                  maxHeight: 32,
                  minWidth: 32,
                ),
                decoration: ShapeDecoration(
                  shape: (labelBuilder != null)
                      ? StadiumBorder()
                      : CircleBorder(),
                  color: boxTheme.onAccent,
                ),
                padding: .symmetric(vertical: 4, horizontal: 8),
                child: (labelBuilder != null)
                    ? Center(
                        child: Text("11mm", style: boxTheme.secondaryTextStyle),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
