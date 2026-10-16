import 'package:box_ui/box_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, this.isFilled = false, required this.onClick});

  final bool isFilled;
  final void Function() onClick;

  Future<String> changeIconColor() async {
    const assetPath =
        'packages/box_ui/assets/icons/right-arrow-direction-square.svg';
    var icon = await rootBundle.loadString(assetPath);

    icon = icon.replaceFirst(
      "rgb(0, 0, 0);",
      "rgb(${boxTheme.accent.r}, ${boxTheme.accent.g}, ${boxTheme.accent.b})",
    );
    icon = icon.replaceFirst(
      "rgb(0, 0, 0);",
      "rgb(${boxTheme.fillColor.r}, ${boxTheme.fillColor.g}, ${boxTheme.fillColor.b})",
    );

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
