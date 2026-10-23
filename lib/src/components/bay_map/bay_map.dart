import 'package:flutter/widgets.dart';

import '../box/box.dart';
import '../interaction/interaction.dart';
import '../../theme/b_emphasis.dart';

enum BBay { frontLeft, frontRight, outerLeft, outerRight }

class BBayMap extends StatelessWidget {
  const BBayMap({
    super.key,
    this.emphasis,
    this.modules = const {},
    this.onSelected,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Map<BBay, String> modules;
  final ValueChanged<BBay>? onSelected;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    Widget bay(BBay b, String label) => Expanded(
      child: BInteraction(
        onActivate: onSelected == null ? null : () => onSelected!(b),
        child: Text(
          '$label\n${modules[b] ?? "空き"}',
          textAlign: TextAlign.center,
        ),
      ),
    );
    return BBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              bay(BBay.outerLeft, '外側 L'),
              const Expanded(child: Text('本体', textAlign: TextAlign.center)),
              bay(BBay.outerRight, '外側 R'),
            ],
          ),
          Row(
            children: [
              bay(BBay.frontLeft, '手前 L'),
              bay(BBay.frontRight, '手前 R'),
            ],
          ),
        ],
      ),
    );
  }
}
