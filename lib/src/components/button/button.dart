import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';

class BButton extends StatefulWidget {
  const new({
    super.key,
    required this.label,
    this.width,
    this.height,
    required this.onClick,
  });

  final String label;
  final double? width;
  final double? height;
  final void Function() onClick;

  @override
  State<BButton> createState() => _BButtonState();
}

class _BButtonState extends State<BButton> {
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
        color: (onHover) ? boxTheme.background : boxTheme.accent,
        borderRadius: .circular(8),
      ),
      child: GestureDetector(
        onTap: () => widget.onClick(),
        child: MouseRegion(
          onEnter: (event) => setState(() => onHover = true),
          onExit: (event) => setState(() => onHover = false),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                (widget.height != null) ? widget.height! * 0.4 : 16,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(widget.label, style: TextStyle(fontSize: 100)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
