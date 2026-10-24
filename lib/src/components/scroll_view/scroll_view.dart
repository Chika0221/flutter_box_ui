import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BScrollView extends StatefulWidget {
  const BScrollView({
    super.key,
    this.emphasis,
    required this.child,
    this.axis = Axis.vertical,
    this.controller,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final Widget child;
  final Axis axis;
  final ScrollController? controller;
  @override
  State<BScrollView> createState() => _BScrollViewState();
}

class _BScrollViewState extends State<BScrollView> {
  final _controller = ScrollController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: widget.emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final c = widget.controller ?? _controller;
    return RawScrollbar(
      thumbColor: BoxTheme.emphasizedOf(context).accent,
      controller: c,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: c,
        scrollDirection: widget.axis,
        child: widget.child,
      ),
    );
  }
}
