import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(child: Center(child: child)),
    );
  }
}
