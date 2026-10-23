import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BDivider extends StatelessWidget {
  const BDivider({
    super.key,
    this.emphasis,
    this.axis = Axis.horizontal,
    this.thickness = 1,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Axis axis;
  final double thickness;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) => Container(
    width: axis == Axis.vertical ? thickness : null,
    height: axis == Axis.horizontal ? thickness : null,
    color: BoxTheme.emphasizedOf(context).borderColor,
  );
}
