import 'package:box_ui/box_ui.dart';
import 'package:box_ui/src/components/slider/slider.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@Preview(name: 'Preview')
Widget mySampleText() {
  boxTheme.changeTheme(
    Color.fromARGB(255, 255, 155, 79),
    Color.fromARGB(255, 36, 49, 36),
  );

  // return BIconButton(icon: BoxIcons.rightArrowDirectionSquare, onClick: () {});
  return HookBuilder(
    builder: (context) {
      final value = useState(false);
      return BSlider();
    },
  );
}
