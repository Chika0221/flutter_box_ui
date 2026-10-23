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
    this.axis = .horizontal,
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

  /// 操作する軸。縦向きは下が最小、上が最大。親で有限の高さを指定する。
  final BSliderAxis axis;

  double _snap(double candidate) {
    final clamped = candidate.clamp(min, max).toDouble();
    final lower = min + ((clamped - min) / interval).floor() * interval;
    final upper = math.min(lower + interval, max);
    return clamped - lower < upper - clamped ? lower : upper;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = BoxTheme.of(context);
    final isHorizontal = axis == BSliderAxis.horizontal;
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
        .merge(theme.secondaryTextStyle);
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
        final length = isHorizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        assert(
          length.isFinite,
          'BSlider requires a bounded size along its axis.',
        );
        final width = isHorizontal ? length : constraints.maxWidth;
        final actualThumbWidth = math.min(thumbWidth, width);
        final thumbExtent = isHorizontal ? actualThumbWidth : 32.0;
        final inset = math.min(math.max(34.0, thumbExtent / 2), length / 2);
        final travel = math.max(0.0, length - inset * 2);
        final ratio = (currentValue - min) / (max - min);

        void updateValue(double x) {
          if (travel == 0) return;
          final nextValue = _snap(min + x / travel * (max - min));
          if (nextValue != currentValue) onChanged?.call(nextValue);
        }

        void startDrag(DragStartDetails details) {
          isDrag.value = true;
          dragPosition.value = ratio * travel;
        }

        void updateDrag(DragUpdateDetails details) {
          final delta = (details.primaryDelta ?? 0) * (isHorizontal ? 1 : -1);
          dragPosition.value = (dragPosition.value + delta)
              .clamp(0.0, travel)
              .toDouble();
          updateValue(dragPosition.value);
        }

        void endDrag(DragEndDetails details) => isDrag.value = false;
        void cancelDrag() => isDrag.value = false;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: enabled && isHorizontal ? startDrag : null,
          onHorizontalDragUpdate: enabled && isHorizontal ? updateDrag : null,
          onHorizontalDragEnd: enabled && isHorizontal ? endDrag : null,
          onHorizontalDragCancel: enabled && isHorizontal ? cancelDrag : null,
          onVerticalDragStart: enabled && !isHorizontal ? startDrag : null,
          onVerticalDragUpdate: enabled && !isHorizontal ? updateDrag : null,
          onVerticalDragEnd: enabled && !isHorizontal ? endDrag : null,
          onVerticalDragCancel: enabled && !isHorizontal ? cancelDrag : null,
          child: SizedBox(
            height: isHorizontal ? 32 : double.infinity,
            width: isHorizontal ? double.infinity : actualThumbWidth,
            child: Stack(
              children: [
                Align(
                  alignment: .center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isHorizontal ? 16 : 0,
                      vertical: isHorizontal ? 0 : 16,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.decelerate,
                      height: isHorizontal
                          ? (enabled && isDrag.value ? 24 : 8)
                          : null,
                      width: isHorizontal
                          ? null
                          : (enabled && isDrag.value ? 24 : 8),
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: theme.accent,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isHorizontal
                            ? (enabled && isDrag.value ? 8 : 4)
                            : 0,
                        horizontal: isHorizontal
                            ? 0
                            : (enabled && isDrag.value ? 8 : 4),
                      ),
                      child: Stack(
                        children: List.generate(divisions + 1, (index) {
                          final tickValue = math.min(
                            min + index * interval,
                            max,
                          );
                          final position =
                              inset -
                              16 +
                              (tickValue - min) / (max - min) * travel -
                              2;
                          return Positioned(
                            left: isHorizontal ? position : 0,
                            right: isHorizontal ? null : 0,
                            top: isHorizontal ? 0 : null,
                            bottom: isHorizontal ? 0 : position,
                            child: Container(
                              width: isHorizontal ? 4 : null,
                              height: isHorizontal ? null : 4,
                              decoration: ShapeDecoration(
                                shape: const StadiumBorder(),
                                color: theme.background,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: isHorizontal
                      ? inset + ratio * travel - actualThumbWidth / 2
                      : 0,
                  bottom: isHorizontal ? null : inset + ratio * travel - 16,
                  child: Container(
                    height: 32,
                    width: actualThumbWidth,
                    decoration: ShapeDecoration(
                      shape: labelBuilder != null
                          ? const StadiumBorder()
                          : const CircleBorder(),
                      color: theme.onAccent,
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
                              style: theme.secondaryTextStyle,
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

enum BSliderAxis { horizontal, vertical }
