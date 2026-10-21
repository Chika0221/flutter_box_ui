import 'package:box_ui/box_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: SizedBox(width: 300, child: child)),
);

Finder get thumb => find
    .descendant(of: find.byType(BSlider), matching: find.byType(Container))
    .last;

void main() {
  testWidgets('minを起点にintervalごとの値・位置・ラベルを更新する', (tester) async {
    var value = 10.0;
    final changes = <double>[];
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => BSlider(
            min: 10,
            max: 20,
            interval: 2,
            value: value,
            labelBuilder: (value) => '${value.toInt()}mm',
            onChanged: (next) {
              changes.add(next);
              setState(() => value = next);
            },
          ),
        ),
      ),
    );
    expect(find.text('10mm'), findsOneWidget);
    final start = tester.getCenter(thumb);
    final gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(20, 0)); // 横ドラッグの認識を開始
    await tester.pump();
    // 1pxずつの移動でも丸め前の移動量が蓄積される。
    for (var i = 0; i < 30; i++) {
      await gesture.moveBy(const Offset(1, 0));
      await tester.pump();
    }
    expect(value, 12);
    expect(find.text('12mm'), findsOneWidget);
    expect(tester.getCenter(thumb).dx, greaterThan(start.dx));
    await gesture.moveBy(const Offset(1000, 0));
    await tester.pump();
    expect(value, 20);
    final bounds = tester.getRect(find.byType(BSlider));
    expect(tester.getRect(thumb).right, lessThanOrEqualTo(bounds.right));
    await gesture.moveBy(const Offset(-1000, 0));
    await tester.pump();
    expect(value, 10);
    expect(tester.getRect(thumb).left, greaterThanOrEqualTo(bounds.left));
    expect(changes.every((value) => (value - 10) % 2 == 0), isTrue);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 8);
  });

  testWidgets('割り切れないintervalでもmaxを選択できる', (tester) async {
    var value = 0.0;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => BSlider(
            min: 0,
            max: 10,
            interval: 3,
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(thumb));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.moveBy(const Offset(1000, 0));
    await tester.pump();
    expect(value, 10);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('親から値が変わると位置とラベルも変わる', (tester) async {
    Widget slider(double value) => host(
      BSlider(
        min: 1,
        max: 2,
        interval: 0.25,
        value: value,
        labelBuilder: (value) => '$value',
      ),
    );
    await tester.pumpWidget(slider(1));
    final start = tester.getCenter(thumb);
    await tester.pumpWidget(slider(1.6));
    expect(find.text('1.5'), findsOneWidget);
    final midpoint = tester.getCenter(thumb);
    await tester.pumpWidget(slider(99));
    expect(find.text('2.0'), findsOneWidget);
    final end = tester.getCenter(thumb);
    expect(midpoint.dx, closeTo((start.dx + end.dx) / 2, 0.01));
  });

  testWidgets('キャンセルでトラックの高さを戻す', (tester) async {
    await tester.pumpWidget(
      host(BSlider(min: 0, max: 10, interval: 1, value: 5, onChanged: (_) {})),
    );
    final gesture = await tester.startGesture(tester.getCenter(thumb));
    await gesture.moveBy(const Offset(20, 0));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 24);
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 8);
  });

  testWidgets('onChangedがnullなら操作で値を変えない', (tester) async {
    await tester.pumpWidget(
      host(
        BSlider(
          min: 0,
          max: 10,
          interval: 1,
          value: 5,
          labelBuilder: (value) => '$value',
        ),
      ),
    );
    final start = tester.getCenter(thumb);
    await tester.drag(find.byType(BSlider), const Offset(200, 0));
    await tester.pumpAndSettle();
    expect(tester.getCenter(thumb), start);
    expect(find.text('5.0'), findsOneWidget);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 8);
  });
}
