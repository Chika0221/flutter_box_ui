import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
    return showGeneralDialog<T>(
      barrierLabel: '閉じる',
      barrierColor: const Color(0x80000000),
      context: context,
      barrierDismissible: barrierDismissible,
      pageBuilder: (_, animation, secondaryAnimation) => BoxTheme(
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

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.enter): ?onConfirm},
      child: Focus(
        autofocus: true,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Semantics(
                  scopesRoute: true,
                  namesRoute: true,
                  label: title,
                  explicitChildNodes: true,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: t.background,
                      border: Border.all(color: t.borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DefaultTextStyle(
                      style: t.body,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(title, style: t.heading),
                          const SizedBox(height: 16),
                          Flexible(child: SingleChildScrollView(child: child)),
                          if (actions.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 8,
                              runSpacing: 8,
                              children: actions,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
