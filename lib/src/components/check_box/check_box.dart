import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../icon/icon.dart';
import '../interaction/interaction.dart';

class BCheckBox extends StatelessWidget {
  const BCheckBox({
    super.key,
    required this.value,
    required this.onClick,
    this.icon,
    this.label,
  });
  final bool value;
  final ValueChanged<bool>? onClick;
  final BIcon? icon;
  final String? label;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return Semantics(
      checked: value,
      child: BInteraction(
        onActivate: onClick == null ? null : () => onClick!(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value ? t.accent : t.fillColor,
                border: Border.all(color: t.accent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: value
                  ? icon ?? Text('✓', style: t.body.copyWith(color: t.onAccent))
                  : null,
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
