import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../interaction/interaction.dart';

class BKeyCap extends StatelessWidget {
  const BKeyCap({
    super.key,
    required this.label,
    this.description,
    this.selected = false,
    this.pending = false,
    this.readOnly = false,
    this.onClick,
  });
  final String label;
  final String? description;
  final bool selected, pending, readOnly;
  final VoidCallback? onClick;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return Semantics(
      label: pending ? '$label, unapplied' : label,
      child: BInteraction(
        onActivate: readOnly ? null : onClick,
        selected: selected,
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: t.fillColor,
            border: Border.all(
              color: pending
                  ? t.warning
                  : selected
                  ? t.accent
                  : t.borderColor,
              width: pending || selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(4),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: t.monospace,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null)
                  Text(
                    description!,
                    style: t.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (pending)
                  Text('•', style: t.caption.copyWith(color: t.warning)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
