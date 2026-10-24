import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../icon/icon.dart';
import '../interaction/interaction.dart';
import '../../theme/b_emphasis.dart';

class BCheckBox extends StatelessWidget {
  const BCheckBox({
    super.key,
    this.emphasis,
    required this.value,
    required this.onClick,
    this.icon,
    this.label,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final bool value;
  final ValueChanged<bool>? onClick;
  final BIcon? icon;
  final String? label;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    return Semantics(
      checked: value,
      child: BInteraction(
        onActivate: onClick == null ? null : () => onClick!(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 24,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 160),
                curve: Curves.decelerate,
                tween: Tween<double>(
                  begin: (value) ? 1 : 0,
                  end: (value) ? 1 : 0,
                ),
                builder: (context, transition, child) {
                  final dip = -4 * transition * (1 - transition);
                  final size = 24 + 4 * dip;

                  return Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: value ? t.accent : t.fillColor,
                      border: Border.all(color: t.accent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: value
                        ? icon ??
                              Text(
                                '✓',
                                style: t.body.copyWith(color: t.onAccent),
                              )
                        : null,
                  );
                },
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label!, style: t.body),
            ],
          ],
        ),
      ),
    );
  }
}
