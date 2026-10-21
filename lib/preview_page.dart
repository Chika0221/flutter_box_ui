import 'package:box_ui/box_ui.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

@Preview(name: 'Preview')
Widget mySampleText() {
  boxTheme.changeTheme(
    Color.fromARGB(255, 255, 155, 79),
    Color.fromARGB(255, 36, 49, 36),
  );

  // return BIconButton(icon: BoxIcons.rightArrowDirectionSquare, onClick: () {});
  return BSwitch();
}
