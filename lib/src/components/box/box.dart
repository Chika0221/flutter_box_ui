import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BBox extends StatelessWidget {
  const BBox({
    super.key,
    this.emphasis,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width, height;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: t.fillColor,
        border: Border.all(color: t.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
