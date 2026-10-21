import 'dart:math' as math;

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
    this.onChanged,
  }) : assert(min > double.negativeInfinity),
       assert(max < double.infinity),
       assert(max > min),
       assert(interval > 0 && interval < double.infinity),
       assert(value > double.negativeInfinity && value < double.infinity);

  final String Function(double value)? labelBuilder;
  final double max;
  final double min;
  final double value;

  /// 目盛りの値の間隔。割り切れない場合は最後の目盛りを [max] にする。
  final double interval;

  /// 親で [value] を更新する。null の場合は操作できない。
  final ValueChanged<double>? onChanged;

  double _snap(double candidate) {
    final clamped = candidate.clamp(min, max).toDouble();
    final lower = min + ((clamped - min) / interval).floor() * interval;
    final upper = math.min(lower + interval, max);
    return clamped - lower < upper - clamped ? lower : upper;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisions = ((max - min) / interval).ceil();
    final currentValue = _snap(value);
    final isDrag = useState(false);
    final dragPosition = useRef(0.0);
    final enabled = onChanged != null;
    final labels = labelBuilder == null
        ? null
        : List.generate(
            divisions + 1,
            (index) => labelBuilder!(math.min(min + index * interval, max)),
          );
    final textStyle = DefaultTextStyle.of(context).style
        .merge(boxTheme.secondaryTextStyle);
    var thumbWidth = 32.0;
    if (labels != null) {
      final painter = TextPainter(
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      );
      for (final label in labels) {
        painter.text = TextSpan(text: label, style: textStyle);
        painter.layout();
        thumbWidth = math.max(thumbWidth, painter.width + 16);
      }
      painter.dispose();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final actualThumbWidth = math.min(thumbWidth, width);
        final inset = math.min(math.max(34.0, actualThumbWidth / 2), width / 2);
        final travel = math.max(0.0, width - inset * 2);
        final ratio = (currentValue - min) / (max - min);

        void updateValue(double x) {
          if (travel == 0) return;
          final nextValue = _snap(min + x / travel * (max - min));
          if (nextValue != currentValue) onChanged?.call(nextValue);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: enabled
              ? (details) {
                  isDrag.value = true;
                  dragPosition.value = ratio * travel;
                }
              : null,
          onHorizontalDragUpdate: enabled
              ? (details) {
                  dragPosition.value =
                      (dragPosition.value + (details.primaryDelta ?? 0))
                          .clamp(0.0, travel)
                          .toDouble();
                  updateValue(dragPosition.value);
                }
              : null,
          onHorizontalDragEnd: enabled ? (_) => isDrag.value = false : null,
          onHorizontalDragCancel: enabled ? () => isDrag.value = false : null,
          child: SizedBox(
            height: 32,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: .center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.decelerate,
                      height: enabled && isDrag.value ? 24 : 8,
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: boxTheme.accent,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: enabled && isDrag.value ? 8 : 4,
                      ),
                      child: Stack(
                        children: List.generate(divisions + 1, (index) {
                          final tickValue = math.min(
                            min + index * interval,
                            max,
                          );
                          return Positioned(
                            left:
                                inset -
                                16 +
                                (tickValue - min) / (max - min) * travel -
                                2,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 4,
                              decoration: ShapeDecoration(
                                shape: const StadiumBorder(),
                                color: boxTheme.background,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: inset + ratio * travel - actualThumbWidth / 2,
                  child: Container(
                    height: 32,
                    width: actualThumbWidth,
                    decoration: ShapeDecoration(
                      shape: labelBuilder != null
                          ? const StadiumBorder()
                          : const CircleBorder(),
                      color: boxTheme.onAccent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: labelBuilder == null
                        ? null
                        : Center(
                            child: Text(
                              labelBuilder!(currentValue),
                              style: boxTheme.secondaryTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
