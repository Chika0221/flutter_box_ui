// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter/widgets.dart';

import '../interaction/interaction.dart';
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
    return tooltip == null
        ? child
        : Tooltip(
            message: tooltip!,
            waitDuration: const Duration(milliseconds: 500),
            child: child,
          );
  }
}
