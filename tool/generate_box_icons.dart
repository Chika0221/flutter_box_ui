import 'dart:convert';
import 'dart:io';

/// Run with: dart run tool/generate_box_icons.dart
Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent;
  final icons = Directory.fromUri(root.uri.resolve('assets/icons/'));
  final output = File.fromUri(root.uri.resolve('lib/src/icons/box_icons.dart'));

  try {
    if (!icons.existsSync()) {
      throw StateError('assets/icons/ が見つかりません。');
    }

    final paths =
        icons
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((file) => file.path.endsWith('.svg'))
            .map(
              (file) => Uri.decodeComponent(
                file.uri.toString().substring(icons.uri.toString().length),
              ),
            )
            .toList()
          ..sort();
    final names = <String, String>{};
    final source = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln('// 更新: dart run tool/generate_box_icons.dart')
      ..writeln()
      ..writeln('abstract final class BoxIcons {');

    for (final path in paths) {
      final words = path
          .substring(0, path.length - 4)
          .split(RegExp('[^a-zA-Z0-9]+'))
          .where((word) => word.isNotEmpty)
          .toList();
      if (words.isEmpty) {
        throw StateError('定数名に変換できないファイル名です: $path');
      }
      var name = words.first[0].toLowerCase() + words.first.substring(1);
      for (final word in words.skip(1)) {
        name += word[0].toUpperCase() + word.substring(1);
      }
      if (RegExp('^[0-9]').hasMatch(name)) {
        name = 'icon$name';
      }
      final previous = names[name];
      if (previous != null) {
        throw StateError('定数名 $name が重複しています: $previous, $path');
      }
      names[name] = path;
      final asset = jsonEncode('packages/box_ui/assets/icons/$path')
          .replaceAll(r'$', r'\$');
      source
        ..writeln('  static const $name =')
        ..writeln('      $asset;')
        ..writeln();
    }
    source.writeln('}');

    // Validate and format before replacing the existing definitions.
    final temporary = Directory.systemTemp.createTempSync('box_icons_');
    try {
      final generated = File('${temporary.path}/box_icons.dart')
        ..writeAsStringSync(source.toString());
      final result = await Process.run(Platform.resolvedExecutable, [
        'format',
        generated.path,
      ]);
      if (result.exitCode != 0) {
        throw StateError('定数名を Dart として生成できません。\n${result.stderr}');
      }
      output.parent.createSync(recursive: true);
      output.writeAsStringSync(generated.readAsStringSync());
    } finally {
      temporary.deleteSync(recursive: true);
    }
    stdout.writeln('box_icons.dart を更新しました（${paths.length} 件）。');
  } on Object catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}
