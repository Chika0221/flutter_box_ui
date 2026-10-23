import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../interaction/interaction.dart';
import '../../theme/b_emphasis.dart';

class BListItem {
  const BListItem({
    required this.label,
    this.leading,
    this.trailing,
    this.enabled = true,
  });
  final String label;
  final Widget? leading, trailing;
  final bool enabled;
}

class BListView extends StatelessWidget {
  const BListView({
    super.key,
    this.emphasis,
    required this.items,
    this.selectedIndex,
    this.onSelected,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final List<BListItem> items;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) => FocusTraversalGroup(
    policy: OrderedTraversalPolicy(),
    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                FocusManager.instance.primaryFocus?.nextFocus(),
            const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                FocusManager.instance.primaryFocus?.previousFocus(),
          },
          child: BInteraction(
            selected: selectedIndex == i,
            onActivate: onSelected == null || !item.enabled
                ? null
                : () => onSelected!(i),
            child: Row(
              children: [
                if (item.leading != null) ...[
                  item.leading!,
                  const SizedBox(width: 8),
                ],
                Expanded(child: Text(item.label)),
                if (item.trailing != null) item.trailing!,
              ],
            ),
          ),
        );
      },
    ),
  );
}
