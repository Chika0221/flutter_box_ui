# アイコン定義の更新

`assets/icons/` に SVG を追加・削除したあと、パッケージのルートで実行します。

```sh
dart run tool/generate_box_icons.dart
```

`lib/src/icons/box_icons.dart` を SVG の一覧から再生成します。このファイルは直接編集せず、スクリプトを再実行してください。

- `right-arrow-direction-square.svg` → `BoxIcons.rightArrowDirectionSquare`
- `navigation/arrow-left.svg` → `BoxIcons.navigationArrowLeft`
- 数字から始まる定数名には `icon` を付けます。
- 定数名が重複したり Dart として無効だったりする場合は、生成先を更新せずエラーを表示します。ファイル名を変更してください。
- ファイルを削除・改名すると、対応する定数も削除・改名されます。

Flutter にアセットを含めるための `pubspec.yaml` の登録は別途必要です。このスクリプトは定義ファイルだけを更新します。現在の個別ファイル登録を維持する場合は、追加した SVG も `flutter.assets` に登録してください。ディレクトリ登録を使う場合も、サブディレクトリはそれぞれ登録してください。
