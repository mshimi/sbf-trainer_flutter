import 'package:flutter/material.dart';

class SplashAppMark extends StatelessWidget {
  const SplashAppMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17C3CE), Color(0xFF0EA5B2)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17C3CE).withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.directions_boat_rounded,
        size: 38,
        color: Colors.white,
      ),
    );
  }
}
