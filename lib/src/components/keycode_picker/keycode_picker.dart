import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../text_field/text_field.dart';
import '../tabs/tabs.dart';
import '../interaction/interaction.dart';

class BKeycode {
  const BKeycode({
    required this.code,
    required this.name,
    required this.category,
  });
  final String code, name, category;
}

/// The application supplies categories and keycodes; no firmware parsing happens here.
class BKeycodePicker extends StatefulWidget {
  const BKeycodePicker({
    super.key,
    required this.keycodes,
    required this.onSelected,
  });
  final List<BKeycode> keycodes;
  final ValueChanged<BKeycode> onSelected;
  @override
  State<BKeycodePicker> createState() => _BKeycodePickerState();
}

class _BKeycodePickerState extends State<BKeycodePicker> {
  String query = '';
  int category = 0, index = 0;
  final scroll = ScrollController();
  final searchFocus = FocusNode();
  @override
  void dispose() {
    searchFocus.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.keycodes.map((k) => k.category).toSet().toList();
    if (category >= categories.length) category = 0;
    final items = widget.keycodes
        .where(
          (k) =>
              (categories.isEmpty || k.category == categories[category]) &&
              '${k.code} ${k.name}'.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (index >= items.length) index = 0;
    void move(int delta) {
      if (items.isEmpty) return;
      setState(() => index = (index + delta) % items.length);
      if (scroll.hasClients) {
        scroll.animateTo(
          (index * 48.0).clamp(0, scroll.position.maxScrollExtent),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    }

    searchFocus.onKeyEvent = (_, event) {
      if (event is KeyDownEvent || event is KeyRepeatEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowUp) {
          move(event.logicalKey == LogicalKeyboardKey.arrowDown ? 1 : -1);
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => move(-1),
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (items.isNotEmpty) widget.onSelected(items[index]);
        },
      },
      child: Column(
        children: [
          BTextField(
            focusNode: searchFocus,
            placeholder: 'キーコードを検索',
            onChanged: (v) => setState(() {
              query = v;
              index = 0;
            }),
            onSubmitted: (_) {
              if (items.isNotEmpty) widget.onSelected(items[index]);
            },
          ),
          if (categories.isNotEmpty)
            BTabs(
              labels: categories,
              selectedIndex: category,
              onSelected: (v) => setState(() {
                category = v;
                index = 0;
              }),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('該当するキーコードはありません'))
                : ListView.builder(
                    controller: scroll,
                    itemExtent: 48,
                    itemCount: items.length,
                    itemBuilder: (context, i) => BInteraction(
                      selected: i == index,
                      onActivate: () => widget.onSelected(items[i]),
                      child: Text('${items[i].code}  ${items[i].name}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
