
import 'package:flutter/material.dart';

class SplashGlowBlobs extends StatelessWidget {
  const SplashGlowBlobs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: -80,
          left: -60,
          child: _Blob(
            color: Color(0xFF17C3CE),
            size: 220,
            alpha: 0.30,
          ),
        ),
        Positioned(
          bottom: -90,
          right: -70,
          child: _Blob(
            color: Color(0xFFD7EFF8),
            size: 260,
            alpha: 0.18,
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final double alpha;

  const _Blob({
    required this.color,
    required this.size,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: alpha),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: alpha),
              blurRadius: 70,
              spreadRadius: 25,
            ),
          ],
        ),
      ),
    );
  }
}
