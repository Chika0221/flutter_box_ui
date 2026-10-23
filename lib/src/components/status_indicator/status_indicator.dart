import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';

enum BStatus { success, warning, error, disconnected }

class BStatusIndicator extends StatelessWidget {
  const BStatusIndicator({
    super.key,
    required this.status,
    required this.label,
  });
  final BStatus status;
  final String label;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    final (symbol, color) = switch (status) {
      BStatus.success => ('✓', t.success),
      BStatus.warning => ('!', t.warning),
      BStatus.error => ('×', t.error),
      BStatus.disconnected => ('−', t.foreground),
    };
    return Semantics(
      label: '${status.name}: $label',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              symbol,
              style: t.body.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(label, style: t.body),
          ],
        ),
      ),
    );
  }
}
