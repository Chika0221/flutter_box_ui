import 'package:box_ui/box_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, this.isFilled = false, required this.onClick});

  final bool isFilled;
  final void Function() onClick;

  String _toSvgRgb(Color color) =>
      'rgb(${(color.r * 255).round()}, '
      '${(color.g * 255).round()}, '
      '${(color.b * 255).round()})';

  Future<String> changeIconColor() async {
    const assetPath =
        'packages/box_ui/assets/icons/right-arrow-direction-square.svg';
    var icon = await rootBundle.loadString(assetPath);

    final fillPattern = RegExp(
      r'''(\bfill\s*:\s*)([^;"']+)|(\bfill\s*=\s*["'])([^"']+)(["'])''',
    );
    final colors = [boxTheme.accent, boxTheme.fillColor];
    var colorIndex = 0;
    icon = icon.replaceAllMapped(fillPattern, (match) {
      if (colorIndex >= colors.length) {
        return match[0]!;
      }

      final color = _toSvgRgb(colors[colorIndex++]);
      return match[1] != null
          ? '${match[1]}$color'
          : '${match[3]}$color${match[5]}';
    });

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(8),
        color: (isFilled) ? boxTheme.fillColor : null,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClick,
        child: Center(
          child: SizedBox.square(
            dimension: 100,
            child: FutureBuilder<String>(
              future: changeIconColor(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                return SvgPicture.string(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
