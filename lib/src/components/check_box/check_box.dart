import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class BCheckBox extends StatelessWidget {
  const BCheckBox({
    super.key,
    required this.value,
    required this.onClick,
    this.icon,
  });

  final bool value;
  final BIcon? icon;
  final ValueChanged<bool> onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick.call(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        curve: Curves.easeInOutBack,
        width: (value) ? 26 : 24,
        height: (value) ? 26 : 24,
        decoration: BoxDecoration(
          borderRadius: .circular(8),
          border: .all(color: boxTheme.accent),
          color: (value) ? boxTheme.accent : boxTheme.fillColor,
        ),
        child: (value)
            ? (icon != null)
                  ? icon
                  : BIcon(
                      icon: BoxIcons.check,
                      foragoundColor: boxTheme.onAccent,
                    )
            : null,
      ),
    );
  }
}
