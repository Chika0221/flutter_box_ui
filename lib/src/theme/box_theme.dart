import 'package:flutter/widgets.dart';

import 'box_theme_data.dart';

/// Supplies a theme to descendants and rebuilds dependents when data changes.
class BoxTheme extends InheritedWidget {
  const BoxTheme({super.key, required this.data, required super.child});

  final BoxThemeData data;

  /// Returns the nearest theme, or the default when no theme is provided.
  static BoxThemeData of(BuildContext context) =>
      maybeOf(context) ?? BoxThemeData.fallback;

  static BoxThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BoxTheme>()?.data;

  @override
  bool updateShouldNotify(BoxTheme oldWidget) => data != oldWidget.data;
}
