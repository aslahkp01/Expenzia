import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every application and test Dart file stays within 100 lines', () {
    for (final directory in ['lib', 'test']) {
      final files = Directory(
        directory,
      ).listSync(recursive: true, followLinks: false).whereType<File>();
      for (final file in files.where((file) => file.path.endsWith('.dart'))) {
        expect(
          file.readAsLinesSync().length,
          lessThanOrEqualTo(100),
          reason: file.path,
        );
      }
    }
  });
}
