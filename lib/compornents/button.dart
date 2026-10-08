import 'package:box_ui/box_ui.dart';
import 'package:material_ui/material_ui.dart';

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
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: (onHover) ? theme.accent : theme.background,
          border: Border.all(color: theme.accent),
        ),
        child: InkWell(
          onHover: (value) {
            setState(() {
              onHover = value;
            });
          },
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
