// Flutter's compatibility export keeps this package usable without a new dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../material_surface/material_surface.dart';

class BTextField extends StatelessWidget {
  const BTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder, errorText;
  final ValueChanged<String>? onChanged, onSubmitted;
  final bool enabled;
  @override
  Widget build(BuildContext context) => BMaterialSurface(
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: 1,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(hintText: placeholder, errorText: errorText),
    ),
  );
}
