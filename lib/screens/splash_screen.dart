import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/splash_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), _finish);
  }

  void _finish() {
    _timer?.cancel();
    if (mounted) widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _finish,
    child: CustomPaint(
      painter: SplashBackground(),
      child: const Center(
        child: Text(
          'Expenzia',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -.8,
          ),
        ),
      ),
    ),
  );
}
