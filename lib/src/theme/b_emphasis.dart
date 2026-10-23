import 'package:flutter/widgets.dart';

/// Visual prominence, independent of selection, button variant, and status.
enum BEmphasis {
  /// Uses the theme's accent palette.
  normal,

  /// Uses the complementary palette for extra attention.
  strong,
}

/// Sets the default prominence for a subtree. A component's explicit
/// [BEmphasis.normal] overrides an enclosing strong scope.
class BEmphasisScope extends InheritedTheme {
  const BEmphasisScope({
    super.key,
    required this.emphasis,
    required super.child,
  });

  final BEmphasis emphasis;

  static BEmphasis of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BEmphasisScope>()?.emphasis ??
      BEmphasis.normal;

  @override
  bool updateShouldNotify(BEmphasisScope oldWidget) =>
      emphasis != oldWidget.emphasis;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      BEmphasisScope(emphasis: emphasis, child: child);
}
