import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../interaction/interaction.dart';

class BTabs extends StatelessWidget {
  const BTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    void move(int delta) {
      if (labels.isNotEmpty) {
        onSelected((selectedIndex + delta) % labels.length);
      }
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.tab, control: true): () =>
            move(1),
        const SingleActivator(
          LogicalKeyboardKey.tab,
          control: true,
          shift: true,
        ): () =>
            move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => move(1),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => move(-1),
        for (var i = 0; i < labels.length && i < 9; i++)
          SingleActivator(
            [
              LogicalKeyboardKey.digit1,
              LogicalKeyboardKey.digit2,
              LogicalKeyboardKey.digit3,
              LogicalKeyboardKey.digit4,
              LogicalKeyboardKey.digit5,
              LogicalKeyboardKey.digit6,
              LogicalKeyboardKey.digit7,
              LogicalKeyboardKey.digit8,
              LogicalKeyboardKey.digit9,
            ][i],
          ): () =>
              onSelected(i),
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              BInteraction(
                selected: i == selectedIndex,
                onActivate: () => onSelected(i),
                child: Text(labels[i]),
              ),
          ],
        ),
      ),
    );
  }
}
