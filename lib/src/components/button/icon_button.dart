import 'dart:async';

import 'package:flutter/widgets.dart';

import '../interaction/interaction.dart';
import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BIconButton extends StatelessWidget {
  const BIconButton({
    super.key,
    this.emphasis,
    required this.icon,
    this.isFilled = false,
    this.onClick,
    this.tooltip,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Widget icon;
  final bool isFilled;
  final VoidCallback? onClick;
  final String? tooltip;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final child = BInteraction(
      onActivate: onClick,
      selected: isFilled,
      child: SizedBox.square(dimension: 24, child: Center(child: icon)),
    );
    return tooltip == null ? child : _BTooltip(message: tooltip!, child: child);
  }
}

/// A tooltip hosted by the widgets overlay, independent of Material localizations.
class _BTooltip extends StatefulWidget {
  const _BTooltip({required this.message, required this.child});
  final String message;
  final Widget child;

  @override
  State<_BTooltip> createState() => _BTooltipState();
}

class _BTooltipState extends State<_BTooltip> {
  final portal = OverlayPortalController();
  final link = LayerLink();
  Timer? timer;

  void hide() {
    timer?.cancel();
    portal.hide();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    return Semantics(
      tooltip: widget.message,
      child: MouseRegion(
        onEnter: (_) {
          timer?.cancel();
          timer = Timer(const Duration(milliseconds: 500), portal.show);
        },
        onExit: (_) => hide(),
        child: Listener(
          onPointerDown: (_) => hide(),
          child: OverlayPortal(
            controller: portal,
            overlayChildBuilder: (_) => Positioned(
              left: 0,
              top: 0,
              child: CompositedTransformFollower(
                link: link,
                targetAnchor: Alignment.bottomCenter,
                followerAnchor: Alignment.topCenter,
                offset: const Offset(0, 4),
                showWhenUnlinked: false,
                child: IgnorePointer(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 240),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: t.foreground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.message,
                      style: t.caption.copyWith(color: t.background),
                    ),
                  ),
                ),
              ),
            ),
            child: CompositedTransformTarget(link: link, child: widget.child),
          ),
        ),
      ),
    );
  }
}
