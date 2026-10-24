import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';

/// Shared desktop activation, focus, pointer and disabled treatment.
class BInteraction extends StatefulWidget {
  const BInteraction({
    super.key,
    required this.child,
    this.onActivate,
    this.selected = false,
    this.padding = const EdgeInsets.all(8),
  });
  final Widget child;
  final VoidCallback? onActivate;
  final bool selected;
  final EdgeInsetsGeometry padding;
  @override
  State<BInteraction> createState() => _BInteractionState();
}

class _BInteractionState extends State<BInteraction> {
  bool hover = false, focus = false, pressed = false;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    final enabled = widget.onActivate != null;
    return Semantics(
      button: true,
      enabled: enabled,
      selected: widget.selected,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: (v) => setState(() => hover = v),
        onShowFocusHighlight: (v) => setState(() => focus = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onActivate?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onActivate,
          onTapDown: enabled ? (_) => setState(() => pressed = true) : null,
          onTapUp: (_) => setState(() => pressed = false),
          onTapCancel: () => setState(() => pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: widget.padding,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: focus ? Border.all(color: t.accent, width: 2) : null,
            ),
            decoration: BoxDecoration(
              color: pressed
                  ? t.borderColor
                  : hover || widget.selected
                  ? t.fillColor
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Opacity(opacity: enabled ? 1 : .45, child: widget.child),
          ),
        ),
      ),
    );
  }
}
