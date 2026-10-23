import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';

enum BTextStyle { heading, body, caption, monospace }

class BText extends StatelessWidget {
  const BText(
    this.data, {
    super.key,
    this.variant = BTextStyle.body,
    this.maxLines,
    this.overflow,
  });
  final String data;
  final BTextStyle variant;
  final int? maxLines;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return Text(
      data,
      style: switch (variant) {
        BTextStyle.heading => t.heading,
        BTextStyle.body => t.body,
        BTextStyle.caption => t.caption,
        BTextStyle.monospace => t.monospace,
      },
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
