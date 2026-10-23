<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## BoxTheme

`BoxTheme` を使うと、子 Widget から `BoxTheme.of(context)` でテーマを参照できます。
指定がない場合は赤いアクセント・白い背景のデフォルトテーマを使用します。

```dart
BoxTheme(
  data: BoxThemeData(
    accent: const Color(0xFFFF9B4F),
    background: const Color(0xFF243124),
  ),
  child: const MyPage(),
)
```

`build` 内で `final theme = BoxTheme.of(context);` と取得し、
`theme.accent` や `theme.secondaryTextStyle` を使用します。
`BoxTheme` を入れ子にすると、その部分だけ別のテーマを適用できます。
テーマを切り替える場合は、親の `setState` などで `data` を新しい
`BoxThemeData` に差し替えてください。参照している子 Widget が再ビルドされます。

旧 API からの移行:

- `BoxCustomTheme(accent, background)` → `BoxThemeData(accent: ..., background: ...)`
- グローバルの `boxTheme` → `BoxTheme.of(context)`
- `changeTheme(...)` → `data.copyWith(accent: ..., background: ...)` で新しいデータを作り、親で差し替え
- `setTextStyle()` → `secondaryTextStyle`

`copyWith(primaryFontFamily: () => 'Roboto')` でフォントを変更し、
`copyWith(primaryFontFamily: () => null)` で解除できます。省略すると元の値を保持します。
