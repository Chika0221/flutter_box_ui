import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('親で状態を更新するとOFFからON、ONからOFFに切り替わる', (tester) async {
    var value = false;
    final changes = <bool>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: StatefulBuilder(
            builder: (context, setState) => BSwitch(
              value: value,
              onChanged: (nextValue) {
                changes.add(nextValue);
                setState(() => value = nextValue);
              },
            ),
          ),
        ),
      ),
    );

    final thumb = find.byType(Container).last;
    final track = find.byType(Container).first;
    expect(tester.getSize(track).height, 12);
    final offPosition = tester.getCenter(thumb);
    final semantics = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.byType(BSwitch)),
      matchesSemantics(
        hasToggledState: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.byType(BSwitch));
    await tester.pump();

    expect(value, isTrue);
    expect(tester.getCenter(thumb), offPosition);
    await tester.pump(const Duration(milliseconds: 100));
    final forwardMidpoint = tester.getCenter(thumb);
    expect(tester.getSize(track).height, greaterThan(12));
    expect(tester.getSize(track).height, lessThanOrEqualTo(20));
    expect(forwardMidpoint.dx, greaterThan(offPosition.dx));
    await tester.pumpAndSettle();
    final onPosition = tester.getCenter(thumb);
    expect(tester.getSize(track).height, 12);
    expect(onPosition.dx, greaterThan(forwardMidpoint.dx));
    expect(onPosition.dy, offPosition.dy);
    expect(
      tester.getSemantics(find.byType(BSwitch)),
      matchesSemantics(
        hasToggledState: true,
        isToggled: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.byType(BSwitch));
    await tester.pump();

    expect(value, isFalse);
    expect(changes, [true, false]);
    expect(tester.getCenter(thumb), onPosition);
    await tester.pump(const Duration(milliseconds: 100));
    final reverseMidpoint = tester.getCenter(thumb);
    expect(tester.getSize(track).height, greaterThan(12));
    expect(reverseMidpoint.dx, lessThan(onPosition.dx));
    expect(reverseMidpoint.dx, greaterThan(offPosition.dx));
    await tester.pumpAndSettle();
    expect(tester.getCenter(thumb), offPosition);
    expect(tester.getSize(track).height, 12);
    semantics.dispose();
  });

  testWidgets('親から渡された値はタップだけでは書き換わらない', (tester) async {
    bool? nextValue;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: BSwitch(value: false, onChanged: (value) => nextValue = value),
        ),
      ),
    );

    await tester.tap(find.byType(BSwitch));
    await tester.pump();

    expect(nextValue, isTrue);
    expect(tester.widget<BSwitch>(find.byType(BSwitch)).value, isFalse);
    expect(tester.getSize(find.byType(Container).first).height, 12);
  });

  testWidgets('onChangedがnullなら操作できない', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: BSwitch(value: true, onChanged: null)),
      ),
    );
    final semantics = tester.ensureSemantics();
    expect(tester.getSize(find.byType(Container).first).height, 12);

    await tester.tap(find.byType(BSwitch));
    await tester.pump();

    expect(
      tester.getSemantics(find.byType(BSwitch)),
      matchesSemantics(
        hasToggledState: true,
        isToggled: true,
        hasEnabledState: true,
      ),
    );
    semantics.dispose();
  });
}
