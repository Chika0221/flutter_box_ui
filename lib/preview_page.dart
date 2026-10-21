import 'package:box_ui/box_ui.dart';
import 'package:box_ui/src/components/slider/slider.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(WidgetsApp(color: Color(0xFFFFFFFF), home: mySampleText()));
}

@Preview(name: 'Preview')
Widget mySampleText() {
  boxTheme.changeTheme(
    Color.fromARGB(255, 255, 155, 79),
    Color.fromARGB(255, 36, 49, 36),
  );

  // return BIconButton(icon: BoxIcons.rightArrowDirectionSquare, onClick: () {});
  return HookBuilder(
    builder: (context) {
      final switchValue = useState(false);
      return Container(
        color: boxTheme.background,
        width: 500,
        padding: .all(8),
        child: Column(
          children: [
            BSwitch(
              value: switchValue.value,
              onChanged: (value) {
                switchValue.value = value;
              },
            ),
            const SizedBox(height: 64),
            BSlider(),
          ],
        ),
      );
    },
  );
}
