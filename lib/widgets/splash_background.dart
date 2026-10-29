import 'dart:math';
import 'package:flutter/material.dart';

class SplashBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF65B5AF), Color(0xFF3F9992)],
        ).createShader(bounds),
    );
    final random = Random(24);
    final grain = Paint()..color = const Color(0x10206059);
    for (var i = 0; i < 16000; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * .7,
        grain,
      );
    }
  }

  @override
  bool shouldRepaint(SplashBackground oldDelegate) => false;
}
