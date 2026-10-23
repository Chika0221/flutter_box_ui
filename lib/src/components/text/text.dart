import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

enum BTextStyle { heading, body, caption, monospace }

class BText extends StatelessWidget {
  const BText(
    this.data, {
    super.key,
    this.emphasis,
    this.variant = BTextStyle.body,
    this.maxLines,
    this.overflow,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final String data;
  final BTextStyle variant;
  final int? maxLines;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    final style = switch (variant) {
      BTextStyle.heading => t.heading,
      BTextStyle.body => t.body,
      BTextStyle.caption => t.caption,
      BTextStyle.monospace => t.monospace,
    };
    return Text(
      data,
      style: BEmphasisScope.of(context) == BEmphasis.strong
          ? style.copyWith(color: t.accent)
          : style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
