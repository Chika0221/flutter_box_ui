import 'package:box_ui/box_ui.dart';
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
      final sliderValue = useState(5.0);
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
            BSlider(
              min: 0,
              max: 10,
              interval: 1,
              value: sliderValue.value,
              onChanged: (value) => sliderValue.value = value,
              labelBuilder: (value) => '${value.toInt()}mm',
            ),
          ],
        ),
      );
    },
  );
}
