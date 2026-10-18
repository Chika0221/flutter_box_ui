import 'dart:convert';

import 'package:box_ui/box_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assetPath =
      'packages/box_ui/assets/icons/right-arrow-direction-square.svg';

  tearDown(() {
    rootBundle.evict(assetPath);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  final cases = {
    'mixed color formats':
        '<svg><rect style="fill:#652d90"/>'
        '<path style="fill: rgb(203, 199, 206);"/></svg>',
    'fill attributes': '<svg><rect fill="red"/><path fill="#ccc"/></svg>',
    'same source and replacement color':
        '<svg><rect style="fill:rgb(255, 0, 0);"/>'
        '<path style="fill:blue;"/></svg>',
  };

  for (final entry in cases.entries) {
    test('recolors the first two fills: ${entry.key}', () async {
      final source = entry.value.replaceFirst(
        '</svg>',
        '<path fill="green"/></svg>',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
            expect(utf8.decode(message!.buffer.asUint8List()), assetPath);
            return ByteData.sublistView(
              Uint8List.fromList(utf8.encode(source)),
            );
          });

      final result = await IconButton(onClick: () {}).changeIconColor();

      expect(result, contains('rgb(255, 0, 0)'));
      expect(result, contains('rgb(255, 217, 217)'));
      expect(result, contains('<path fill="green"/>'));
      expect(RegExp(r'rgb\(255, 0, 0\)').allMatches(result), hasLength(1));
    });
  }
}
