import 'package:flutter/widgets.dart';

import '../interaction/interaction.dart';
import '../../theme/b_emphasis.dart';

class BSidebarItem {
  const BSidebarItem({required this.label, required this.icon});
  final String label;
  final Widget icon;
}

/// Legacy header/body construction remains available.
class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
    this.emphasis,
    this.header,
    this.body,
    this.items = const [],
    this.selectedIndex = 0,
    this.onSelected,
    this.initiallyExpanded = true,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Widget? header, body;
  final List<BSidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final bool initiallyExpanded;
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late bool expanded = widget.initiallyExpanded;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: widget.emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 160),
    width: expanded ? 200 : 56,
    child: Column(
      children: [
        if (widget.header != null) widget.header!,
        BInteraction(
          onActivate: () => setState(() => expanded = !expanded),
          child: Semantics(
            label: expanded ? 'Collapse sidebar' : 'Expand sidebar',
            child: const Text('☰'),
          ),
        ),
        if (widget.body != null)
          Expanded(child: widget.body!)
        else
          Expanded(
            child: ListView(
              children: [
                for (var i = 0; i < widget.items.length; i++)
                  BInteraction(
                    selected: i == widget.selectedIndex,
                    onActivate: widget.onSelected == null
                        ? null
                        : () => widget.onSelected!(i),
                    child: Semantics(
                      label: widget.items[i].label,
                      child: Row(
                        children: [
                          widget.items[i].icon,
                          if (expanded) ...[
                            const SizedBox(width: 8),
                            Expanded(child: Text(widget.items[i].label)),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}
