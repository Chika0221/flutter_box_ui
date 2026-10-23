// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../material_surface/material_surface.dart';
import '../../theme/box_theme.dart';

class BDialog extends StatelessWidget {
  const BDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.onConfirm,
  });
  final String title;
  final Widget child;
  final List<Widget> actions;
  final VoidCallback? onConfirm;
  static Future<T?> show<T>(
    BuildContext context, {
    required BDialog dialog,
    bool barrierDismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => BoxTheme(data: BoxTheme.of(context), child: dialog),
  );
  @override
  Widget build(BuildContext context) => BMaterialSurface(
    child: CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.enter): ?onConfirm},
      child: Focus(
        autofocus: true,
        child: AlertDialog(
          title: Text(title),
          content: child,
          actions: actions,
        ),
      ),
    ),
  );
}
