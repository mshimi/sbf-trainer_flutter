import 'package:flutter/material.dart';

class SplashProgress extends StatelessWidget {
  const SplashProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: null,
          backgroundColor: Colors.white.withValues(alpha: 0.16),
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withValues(alpha: 0.90),
          ),
        ),
      ),
    );
  }
}
