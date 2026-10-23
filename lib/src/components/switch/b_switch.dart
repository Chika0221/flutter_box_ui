import 'package:box_ui/src/theme/box_theme.dart';
import 'package:flutter/widgets.dart';

import '../../theme/b_emphasis.dart';

class BSwitch extends StatelessWidget {
  const BSwitch({
    super.key,
    this.emphasis,
    required this.value,
    required this.onChanged,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final theme = BoxTheme.emphasizedOf(context);
    void toggle() => onChanged?.call(!value);

    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : toggle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: onChanged == null ? null : toggle,
        child: SizedBox(
          height: 32,
          width: 64,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: value ? 1 : 0, end: value ? 1 : 0),
              duration: const Duration(milliseconds: 160),
              curve: Curves.decelerate,
              builder: (context, position, child) => Stack(
                children: [
                  Align(
                    alignment: .center,
                    child: Container(
                      height: 8 + (32 - 8) * (1 - (2 * position - 1).abs()),
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: .circular(24),
                        border: .all(color: theme.accent),
                        color: (value) ? theme.accent : theme.fillColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-1 + 2 * position, 0),
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: theme.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
