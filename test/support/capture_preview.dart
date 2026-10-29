import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadPreviewFonts(WidgetTester tester) async {
  final sdk = Platform.environment['FLUTTER_ROOT'];
  if (sdk == null) throw StateError('Set FLUTTER_ROOT to capture previews.');
  await tester.runAsync(() async {
    final loader = FontLoader('Roboto');
    for (final weight in ['regular', 'medium', 'bold', 'black']) {
      final file = File(
        '$sdk/bin/cache/artifacts/material_fonts/roboto-$weight.ttf',
      );
      loader.addFont(file.readAsBytes().then(ByteData.sublistView));
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons');
    icons.addFont(
      File(
        '$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
      ).readAsBytes().then(ByteData.sublistView),
    );
    await icons.load();
  });
}

Future<void> capturePreview(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('preview')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory('docs/screenshots').create(recursive: true);
    await File(
      'docs/screenshots/$name.png',
    ).writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}
