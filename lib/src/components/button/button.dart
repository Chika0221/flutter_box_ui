import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../interaction/interaction.dart';

enum BButtonVariant { primary, secondary, ghost }

class BButton extends StatelessWidget {
  const BButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    this.onClick,
    this.variant = BButtonVariant.primary,
  });
  final String label;
  final double? width, height;
  final VoidCallback? onClick;
  final BButtonVariant variant;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: BInteraction(
        onActivate: onClick,
        child: Container(
          constraints: const BoxConstraints(minHeight: 28),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: variant == BButtonVariant.primary
                ? t.accent
                : variant == BButtonVariant.secondary
                ? t.fillColor
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              style: t.body.copyWith(
                color: variant == BButtonVariant.primary
                    ? t.onAccent
                    : t.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
