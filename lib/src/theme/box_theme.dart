import 'package:flutter/widgets.dart';

import 'box_theme_data.dart';
import 'b_emphasis.dart';

/// Supplies a theme to descendants and rebuilds dependents when data changes.
class BoxTheme extends InheritedWidget {
  const BoxTheme({super.key, required this.data, required super.child});

  final BoxThemeData data;

  /// Returns the nearest theme, or the default when no theme is provided.
  static BoxThemeData of(BuildContext context) =>
      maybeOf(context) ?? BoxThemeData.fallback;

  /// Resolves the current prominence without changing the base theme returned
  /// by [of]. Repeated strong scopes always use the original complementary color.
  static BoxThemeData emphasizedOf(BuildContext context) {
    final theme = of(context);
    return BEmphasisScope.of(context) == BEmphasis.strong
        ? theme.emphasized
        : theme;
  }

  static BoxThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BoxTheme>()?.data;

  @override
  bool updateShouldNotify(BoxTheme oldWidget) => data != oldWidget.data;
}
