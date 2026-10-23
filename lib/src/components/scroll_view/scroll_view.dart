// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

class BScrollView extends StatefulWidget {
  const BScrollView({
    super.key,
    required this.child,
    this.axis = Axis.vertical,
    this.controller,
  });
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
  Widget build(BuildContext context) {
    final c = widget.controller ?? _controller;
    return Scrollbar(
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
