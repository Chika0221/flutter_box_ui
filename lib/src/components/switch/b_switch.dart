import 'package:box_ui/src/theme/box_theme.dart';
import 'package:flutter/widgets.dart';

class BSwitch extends StatelessWidget {
  const BSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    void toggle() => onChanged?.call(!value);

    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : toggle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: onChanged == null ? null : toggle,
        child: SizedBox(
          height: 32,
          width: 64,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                Align(
                  alignment: .center,
                  child: Container(
                    height: 12,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: .circular(24),
                      color: boxTheme.fillColor,
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.decelerate,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: boxTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
