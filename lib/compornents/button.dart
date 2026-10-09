import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class Button extends StatefulWidget {
  const new({super.key, required this.label, this.width, this.height});

  final String label;
  final double? width;
  final double? height;

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
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: (onHover) ? theme.accent : theme.background,
        border: Border.all(color: theme.accent),
      ),
      child: MouseRegion(
        onEnter: (event) => setState(() => onHover = true),
        onExit: (event) => setState(() => onHover = false),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              (widget.height != null) ? widget.height! * 0.2 : 8,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(widget.label, style: TextStyle(fontSize: 100)),
            ),
          ),
        ),
      ),
    );
  }
}
