import 'package:flutter/widgets.dart';

class BoxCustomTheme {
  Color accent;
  Color background;

  late Color complementary;
  late Color fillColor;
  late Color borderColor;
  late Color onAccent;
  late Color foreground;

  BoxCustomTheme(this.accent, this.background) {
    _derive();
  }

  void changeTheme(Color accentColor, Color backgroundColor) {
    accent = accentColor;
    background = backgroundColor;
    _derive();
  }

  void _derive() {
    final hsl = HSLColor.fromColor(accent);
    complementary = hsl.withHue((hsl.hue + 180) % 360).toColor();
    fillColor = Color.lerp(background, accent, 0.08)!;
    borderColor = Color.lerp(background, accent, 0.3)!;
    onAccent = _contrastOn(accent);
    foreground = _contrastOn(background);
  }

  static Color _contrastOn(Color c) => c.computeLuminance() > 0.5
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
}

final theme = BoxCustomTheme(Color(0xFFFF0000), Color(0xFFFFFFFF));
