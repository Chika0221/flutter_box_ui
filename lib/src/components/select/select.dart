// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../material_surface/material_surface.dart';

class BSelectOption<T> {
  const BSelectOption({required this.value, required this.label});
  final T value;
  final String label;
}

class BSelect<T> extends StatelessWidget {
  const BSelect({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
  });
  final List<BSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;
  @override
  Widget build(BuildContext context) => BMaterialSurface(
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
