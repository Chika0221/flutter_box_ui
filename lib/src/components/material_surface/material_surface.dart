// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../theme/box_theme.dart';

/// Bridges Flutter's accessible desktop controls to the package palette.
class BMaterialSurface extends StatelessWidget {
  const BMaterialSurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: t.accent,
              brightness: t.background.computeLuminance() > .5
                  ? Brightness.light
                  : Brightness.dark,
            ).copyWith(
              primary: t.accent,
              onPrimary: t.onAccent,
              surface: t.background,
              onSurface: t.foreground,
              outline: t.borderColor,
            ),
        textTheme: TextTheme(bodyMedium: t.body),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: t.fillColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
