// ignore: deprecated_member_use
import 'package:flutter/material.dart' show Scrollbar;
import 'package:flutter/widgets.dart';

import '../../theme/box_theme.dart';
import '../interaction/interaction.dart';

class BTableColumn {
  const BTableColumn({
    required this.label,
    this.width = 160,
    this.minWidth = 64,
  }) : assert(width >= minWidth),
       assert(minWidth > 0);
  final String label;
  final double width, minWidth;
}

/// A bounded height keeps the header fixed while body rows scroll.
class BTable extends StatefulWidget {
  const BTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowSelected,
    this.selectedRow,
  }) : assert(columns.length > 0);
  final List<BTableColumn> columns;
  final List<List<Widget>> rows;
  final ValueChanged<int>? onRowSelected;
  final int? selectedRow;
  @override
  State<BTable> createState() => _BTableState();
}

class _BTableState extends State<BTable> {
  late List<double> widths = widget.columns.map((c) => c.width).toList();
  final horizontal = ScrollController(), vertical = ScrollController();
  @override
  void didUpdateWidget(covariant BTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columns != widget.columns) {
      widths = widget.columns.map((c) => c.width).toList();
    }
  }

  @override
  void dispose() {
    horizontal.dispose();
    vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = BoxTheme.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        assert(c.hasBoundedHeight, 'BTable requires a bounded height.');
        return Scrollbar(
          controller: horizontal,
          thumbVisibility: true,
          notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
          child: SingleChildScrollView(
            controller: horizontal,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: widths.fold<double>(0, (a, b) => a + b),
              height: c.maxHeight,
              child: Column(
                children: [
                  Container(
                    color: t.fillColor,
                    child: Row(
                      children: [
                        for (var i = 0; i < widths.length; i++)
                          SizedBox(
                            width: widths[i],
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      widget.columns[i].label,
                                      style: t.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.resizeColumn,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onHorizontalDragUpdate: (d) => setState(
                                      () => widths[i] = (widths[i] + d.delta.dx)
                                          .clamp(
                                            widget.columns[i].minWidth,
                                            double.infinity,
                                          ),
                                    ),
                                    child: const SizedBox(width: 8, height: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: vertical,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: vertical,
                        itemCount: widget.rows.length,
                        itemBuilder: (context, r) => BInteraction(
                          padding: EdgeInsets.zero,
                          selected: widget.selectedRow == r,
                          onActivate: widget.onRowSelected == null
                              ? null
                              : () => widget.onRowSelected!(r),
                          child: Row(
                            children: [
                              for (var i = 0; i < widths.length; i++)
                                SizedBox(
                                  width: widths[i],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: i < widget.rows[r].length
                                        ? widget.rows[r][i]
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
