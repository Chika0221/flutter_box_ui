import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late bool onHover;

  @override
  void initState() {
    super.initState();

    onHover = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (onHover) ? theme.accent : theme.background,
        border: Border.all(color: theme.accent),
      ),
      child: MouseRegion(
        onEnter: (event) => setState(() => onHover = true),
        onExit: (event) => setState(() => onHover = false),
        child: Center(child: widget.child),
      ),
    );
  }
}
