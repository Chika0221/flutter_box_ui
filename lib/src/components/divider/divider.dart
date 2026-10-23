import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';

class BDivider extends StatelessWidget {
  const BDivider({super.key, this.axis = Axis.horizontal, this.thickness = 1});
  final Axis axis;
  final double thickness;
  @override
  Widget build(BuildContext context) => Container(
    width: axis == Axis.vertical ? thickness : null,
    height: axis == Axis.horizontal ? thickness : null,
    color: BoxTheme.of(context).borderColor,
  );
}
