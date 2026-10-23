import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class BCheckBox extends StatelessWidget {
  const BCheckBox({
    super.key,
    required this.value,
    required this.onClick,
    this.icon,
  });

  final bool value;
  final BIcon? icon;
  final ValueChanged<bool> onClick;

  @override
  Widget build(BuildContext context) {
    final theme = BoxTheme.of(context);
    return SizedBox.square(
      dimension: 24,
      child: Center(
        child: GestureDetector(
          onTap: () => onClick.call(!value),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: (value) ? 1 : 0, end: (value) ? 1 : 0),
            duration: Duration(milliseconds: 160),
            curve: Curves.decelerate,
            builder: (context, transition, child) {
              final dip = -4 * transition * (1 - transition);
              final size = 24 + 4 * dip;

              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: .circular(8),
                  border: .all(color: theme.accent),
                  color: (value) ? theme.accent : theme.fillColor,
                ),
                child: (value)
                    ? (icon != null)
                          ? icon
                          : BIcon(
                              icon: BoxIcons.check,
                              foragoundColor: theme.onAccent,
                            )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
