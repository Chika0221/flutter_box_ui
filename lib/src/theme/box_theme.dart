import 'package:flutter/widgets.dart';

class BoxCustomTheme {
  Color accent;
  Color background;
  String? primaryFontFamily;
  String? secondaryFontFamily;

  late Color complementary;
  late Color fillColor;
  late Color borderColor;
  late Color onAccent;
  late Color foreground;
  late TextStyle primaryTextStyle;
  late TextStyle secondaryTextStyle;

  BoxCustomTheme(
    this.accent,
    this.background, {
    this.primaryFontFamily,
    this.secondaryFontFamily,
  }) {
    _derive();
  }

  void changeTheme(
    Color accentColor,
    Color backgroundColor, {
    String? primaryFontFamily,
    String? secondaryFontFamily,
  }) {
    accent = accentColor;
    background = backgroundColor;
    this.primaryFontFamily = primaryFontFamily ?? this.primaryFontFamily;
    this.secondaryFontFamily = secondaryFontFamily ?? this.secondaryFontFamily;
    _derive();
  }

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

  TextStyle setTextStyle() {
    return secondaryTextStyle;
  }

  static Color _contrastOn(Color c) => c.computeLuminance() > 0.5
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}

final boxTheme = BoxCustomTheme(
  const Color(0xFFFF0000),
  const Color(0xFFFFFFFF),
  primaryFontFamily: 'Roboto',
  secondaryFontFamily: 'NotoSansJP',
);
