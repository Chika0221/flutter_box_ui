import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideBar extends HookConsumerWidget {
  const SideBar({super.key, this.header, required this.body});

  final Widget? header;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = useState(true);

    return AnimatedContainer(
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 160),
      width: isOpen.value ? 200 : 32,
      child: (header != null)
          ? Column(
              mainAxisSize: .max,
              children: [header!, SizedBox(height: 16), body],
            )
          : body,
    );
  }
}
