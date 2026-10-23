import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class BIconButton extends StatelessWidget {
  const BIconButton({
    super.key,
    required this.icon,
    this.isFilled = false,
    required this.onClick,
  });

  final Widget icon;
  final bool isFilled;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    final theme = BoxTheme.of(context);
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(8),
          color: (isFilled) ? theme.fillColor : null,
        ),
        child: icon,
      ),
    );
  }
}
