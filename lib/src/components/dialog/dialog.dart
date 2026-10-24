// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../material_surface/material_surface.dart';
import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BDialog extends StatelessWidget {
  const BDialog({
    super.key,
    this.emphasis,
    required this.title,
    required this.child,
    this.actions = const [],
    this.onConfirm,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final String title;
  final Widget child;
  final List<Widget> actions;
  final VoidCallback? onConfirm;
  static Future<T?> show<T>(
    BuildContext context, {
    required BDialog dialog,
    bool barrierDismissible = true,
  }) {
    final data = BoxTheme.of(context);
    final emphasis = BEmphasisScope.of(context);
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => BoxTheme(
        data: data,
        child: BEmphasisScope(emphasis: emphasis, child: dialog),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) => BMaterialSurface(
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
