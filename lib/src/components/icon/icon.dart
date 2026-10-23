import 'package:box_ui/box_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BIcon extends StatelessWidget {
  const BIcon({
    super.key,
    this.size = .m,
    required this.icon,
    this.foragoundColor,
    this.backgroundColor,
  });

  final String icon;
  final BIconSize size;
  final Color? foragoundColor;
  final Color? backgroundColor;

  String _toSvgRgb(Color color) =>
      'rgb(${(color.r * 255).round()}, '
      '${(color.g * 255).round()}, '
      '${(color.b * 255).round()})';

  Future<String> _changeIconColor(Color fColor, Color bColor) async {
    final assetPath = icon;
    var iconString = await rootBundle.loadString(assetPath);

    final fillPattern = RegExp(
      r'''(\bfill\s*:\s*)([^;"']+)|(\bfill\s*=\s*["'])([^"']+)(["'])''',
    );
    final colors = [fColor, bColor];
    var colorIndex = 0;
    iconString = iconString.replaceAllMapped(fillPattern, (match) {
      if (colorIndex >= colors.length) {
        return match[0]!;
      }

      final color = _toSvgRgb(colors[colorIndex++]);
      return match[1] != null
          ? '${match[1]}$color'
          : '${match[3]}$color${match[5]}';
    });

    final strokePattern = RegExp(
      r'''(\bstroke\s*:\s*)([^;"']+)|(\bstroke\s*=\s*["'])([^"']+)(["'])''',
    );
    colorIndex = 0;
    iconString = iconString.replaceAllMapped(strokePattern, (match) {
      if (colorIndex >= colors.length) {
        return match[0]!;
      }

      final color = _toSvgRgb(colors[colorIndex++]);
      return match[1] != null
          ? '${match[1]}$color'
          : '${match[3]}$color${match[5]}';
    });

    return iconString;
  }

  @override
  Widget build(BuildContext context) {
    final theme = BoxTheme.of(context);
    return SizedBox.square(
      dimension: size.value,
      child: SizedBox.square(
        dimension: 100,
        child: FutureBuilder<String>(
          future: _changeIconColor(
            foragoundColor ?? theme.accent,
            backgroundColor ?? theme.fillColor,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            return SvgPicture.string(snapshot.data!);
          },
        ),
      ),
    );
  }
}

enum BIconSize {
  ss(24),
  s(32),
  m(48),
  l(64);

  final double value;
  const BIconSize(this.value);
}
