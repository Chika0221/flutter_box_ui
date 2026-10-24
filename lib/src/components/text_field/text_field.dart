import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../theme/box_theme.dart';
import '../../theme/b_emphasis.dart';

class BTextField extends StatefulWidget {
  const BTextField({
    super.key,
    this.emphasis,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  /// Inherits the enclosing scope when null; strong uses complementary colors.
  final BEmphasis? emphasis;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder, errorText;
  final ValueChanged<String>? onChanged, onSubmitted;
  final bool enabled;
  @override
  State<BTextField> createState() => _BTextFieldState();
}

class _BTextFieldState extends State<BTextField> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  TextEditingController get controller =>
      widget.controller ?? (_controller ??= TextEditingController());
  FocusNode get focusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BEmphasisScope(
    emphasis: widget.emphasis ?? BEmphasisScope.of(context),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final t = BoxTheme.emphasizedOf(context);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, focusNode]),
      builder: (context, _) => Semantics(
        enabled: widget.enabled,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.enabled ? focusNode.requestFocus : null,
              child: Container(
                constraints: const BoxConstraints(minHeight: 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: t.fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.errorText != null
                        ? t.error
                        : focusNode.hasFocus
                        ? t.accent
                        : t.borderColor,
                  ),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    if (controller.text.isEmpty && widget.placeholder != null)
                      IgnorePointer(
                        child: Text(
                          widget.placeholder!,
                          style: t.body.copyWith(
                            color: t.foreground.withValues(alpha: .5),
                          ),
                        ),
                      ),
                    ExcludeFocus(
                      excluding: !widget.enabled,
                      child: IgnorePointer(
                        ignoring: !widget.enabled,
                        child: EditableText(
                          controller: controller,
                          focusNode: focusNode,
                          readOnly: !widget.enabled,
                          style: t.body,
                          cursorColor: t.accent,
                          backgroundCursorColor: t.borderColor,
                          selectionColor: t.accent.withValues(alpha: .3),
                          textInputAction: TextInputAction.done,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  widget.errorText!,
                  style: t.caption.copyWith(color: t.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
