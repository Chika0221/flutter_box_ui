import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';
import '../interaction/interaction.dart';

class BSelectOption<T> {
  const BSelectOption({required this.value, required this.label});
  final T value;
  final String label;
}

class BSelect<T> extends StatelessWidget {
  const BSelect({
    super.key,
    this.emphasis,
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final List<BSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    final selected = options.where((option) => option.value == value);
    return Semantics(
      expanded: false,
      child: BInteraction(
        onActivate: onChanged == null || options.isEmpty
            ? null
            : () => _open(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: t.fillColor,
            border: Border.all(color: t.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected.isEmpty ? placeholder ?? '' : selected.first.label,
                  style: t.body,
                ),
              ),
              Text('▾', style: t.body),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final t = BoxTheme.emphasizedOf(context);
    final baseTheme = BoxTheme.of(context);
    final emphasis = BEmphasisScope.of(context);
    final box = context.findRenderObject()! as RenderBox;
    final navigator = Navigator.of(context, rootNavigator: true);
    final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero, ancestor: overlay);
    final size = box.size;
    var index = options.indexWhere((option) => option.value == value);
    if (index < 0) index = 0;
    // Return the option rather than its value so nullable values remain selectable.
    final scroll = ScrollController(initialScrollOffset: index * 40.0);
    void move(int delta, StateSetter setState) {
      setState(() => index = (index + delta) % options.length);
      if (scroll.hasClients) {
        final top = index * 40.0;
        final bottom = top + 40;
        if (top < scroll.offset ||
            bottom > scroll.offset + scroll.position.viewportDimension) {
          scroll.jumpTo(top.clamp(0.0, scroll.position.maxScrollExtent));
        }
      }
    }

    BSelectOption<T>? option;
    try {
      option = await showGeneralDialog<BSelectOption<T>>(
        context: context,
        barrierDismissible: true,
        barrierLabel: '閉じる',
        barrierColor: const Color(0x00000000),
        transitionDuration: Duration.zero,
        pageBuilder: (routeContext, animation, secondaryAnimation) {
          final viewport = MediaQuery.sizeOf(routeContext);
          final width = size.width.clamp(0.0, viewport.width);
          final below = viewport.height - origin.dy - size.height;
          final above = origin.dy.clamp(0.0, viewport.height);
          final openBelow = below >= 160 || below >= above;
          final height = (openBelow ? below : above).clamp(0.0, 280.0);
          return BoxTheme(
            data: baseTheme,
            child: BEmphasisScope(
              emphasis: emphasis,
              child: StatefulBuilder(
                builder: (context, setState) => CallbackShortcuts(
                  bindings: {
                    const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                        move(1, setState),
                    const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                        move(-1, setState),
                    const SingleActivator(LogicalKeyboardKey.enter): () =>
                        Navigator.pop(routeContext, options[index]),
                    const SingleActivator(LogicalKeyboardKey.space): () =>
                        Navigator.pop(routeContext, options[index]),
                  },
                  child: Focus(
                    autofocus: true,
                    child: Stack(
                      children: [
                        Positioned(
                          left: origin.dx.clamp(0.0, viewport.width - width),
                          top: openBelow ? origin.dy + size.height : null,
                          bottom: openBelow
                              ? null
                              : viewport.height - origin.dy,
                          width: width,
                          child: Container(
                            constraints: BoxConstraints(maxHeight: height),
                            decoration: BoxDecoration(
                              color: t.background,
                              border: Border.all(color: t.borderColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(4),
                            child: ListView(
                              controller: scroll,
                              itemExtent: 40,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children: [
                                for (var i = 0; i < options.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: BInteraction(
                                      selected: i == index,
                                      onActivate: () => Navigator.pop(
                                        routeContext,
                                        options[i],
                                      ),
                                      child: Text(
                                        options[i].label,
                                        style: t.body,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } finally {
      scroll.dispose();
    }
    if (context.mounted && option != null) onChanged?.call(option.value);
  }
}
