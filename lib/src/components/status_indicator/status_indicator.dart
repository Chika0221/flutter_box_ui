import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

enum BStatus { success, warning, error, disconnected }

class BStatusIndicator extends StatelessWidget {
  const BStatusIndicator({
    super.key,
    this.emphasis,
    required this.status,
    required this.label,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final BStatus status;
  final String label;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
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
