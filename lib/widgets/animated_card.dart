import 'package:flutter/material.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;

  const AnimatedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}
