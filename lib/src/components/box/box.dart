import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';

class BBox extends StatelessWidget {
  const BBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width, height;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
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
