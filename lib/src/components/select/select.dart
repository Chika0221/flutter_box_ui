// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../material_surface/material_surface.dart';
import '../../theme/b_emphasis.dart';

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

  Widget _build(BuildContext context) => BMaterialSurface(
    child: DropdownButton<T>(
      value: value,
      hint: placeholder == null ? null : Text(placeholder!),
      isExpanded: true,
      items: [
        for (final o in options)
          DropdownMenuItem(value: o.value, child: Text(o.label)),
      ],
      onChanged: onChanged,
    ),
  );
}
