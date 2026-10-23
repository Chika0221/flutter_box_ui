import 'package:flutter/widgets.dart';

/// Immutable colors and typography shared by box_ui components.
@immutable
class BoxThemeData {
  final Color accent;
  final Color background;
  final String? primaryFontFamily;
  final String? secondaryFontFamily;

  late final Color complementary;
  late final Color fillColor;
  late final Color borderColor;
  late final Color onAccent;
  late final Color foreground;
  late final TextStyle primaryTextStyle;
  late final TextStyle secondaryTextStyle;

  BoxThemeData({
    required this.accent,
    required this.background,
    this.primaryFontFamily,
    this.secondaryFontFamily,
  }) {
    _derive();
  }

  static final fallback = BoxThemeData(
    accent: const Color(0xFFFF0000),
    background: const Color(0xFFFFFFFF),
    primaryFontFamily: 'Roboto',
    secondaryFontFamily: 'NotoSansJP',
  );

  /// Pass null explicitly to clear a font family.
  BoxThemeData copyWith({
    Color? accent,
    Color? background,
    String? Function()? primaryFontFamily,
    String? Function()? secondaryFontFamily,
  }) => BoxThemeData(
    accent: accent ?? this.accent,
    background: background ?? this.background,
    primaryFontFamily: primaryFontFamily == null
        ? this.primaryFontFamily
        : primaryFontFamily(),
    secondaryFontFamily: secondaryFontFamily == null
        ? this.secondaryFontFamily
        : secondaryFontFamily(),
  );

  void _derive() {
    final hsl = HSLColor.fromColor(accent);
    complementary = hsl.withHue((hsl.hue + 180) % 360).toColor();
    fillColor = Color.lerp(background, accent, 0.15)!;
    borderColor = Color.lerp(background, accent, 0.3)!;
    onAccent = _contrastOn(accent);
    foreground = _contrastOn(background);
    primaryTextStyle = TextStyle(
      fontFamily: primaryFontFamily,
      color: foreground,
    );
    secondaryTextStyle = TextStyle(
      fontFamily: secondaryFontFamily,
      color: foreground,
    );
  }

  static Color _contrastOn(Color c) => c.computeLuminance() > 0.5
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}
