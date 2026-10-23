import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../key_cap/key_cap.dart';

/// Coordinates and sizes use logical key units; rotation is in radians about the key center.
class BKeyGeometry {
  const BKeyGeometry({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    this.width = 1,
    this.height = 1,
    this.rotation = 0,
    this.description,
    this.pending = false,
    this.readOnly = false,
  }) : assert(width > 0),
       assert(height > 0);
  final String id, label;
  final String? description;
  final double x, y, width, height, rotation;
  final bool pending, readOnly;
}

class BKeyboardLayout extends StatelessWidget {
  const BKeyboardLayout({
    super.key,
    required this.keys,
    this.selectedId,
    this.onSelected,
    this.unitSize = 64,
  }) : assert(unitSize > 0);
  final List<BKeyGeometry> keys;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final double unitSize;
  @override
  Widget build(BuildContext context) {
    if (keys.isEmpty) return const SizedBox.shrink();
    double left = double.infinity,
        top = double.infinity,
        right = double.negativeInfinity,
        bottom = double.negativeInfinity;
    for (final k in keys) {
      final w = k.width * unitSize,
          h = k.height * unitSize,
          cx = (k.x + k.width / 2) * unitSize,
          cy = (k.y + k.height / 2) * unitSize;
      final dx =
              (w * math.cos(k.rotation).abs() +
                  h * math.sin(k.rotation).abs()) /
              2,
          dy =
              (w * math.sin(k.rotation).abs() +
                  h * math.cos(k.rotation).abs()) /
              2;
      left = math.min(left, cx - dx);
      right = math.max(right, cx + dx);
      top = math.min(top, cy - dy);
      bottom = math.max(bottom, cy + dy);
    }
    return AspectRatio(
      aspectRatio: (right - left) / (bottom - top),
      child: FittedBox(
        child: SizedBox(
          width: right - left,
          height: bottom - top,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final k in keys)
                Positioned(
                  left: k.x * unitSize - left,
                  top: k.y * unitSize - top,
                  width: k.width * unitSize,
                  height: k.height * unitSize,
                  child: Transform.rotate(
                    angle: k.rotation,
                    child: BKeyCap(
                      label: k.label,
                      description: k.description,
                      selected: k.id == selectedId,
                      pending: k.pending,
                      readOnly: k.readOnly,
                      onClick: onSelected == null
                          ? null
                          : () => onSelected!(k.id),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
