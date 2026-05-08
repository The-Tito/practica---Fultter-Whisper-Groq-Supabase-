import 'dart:ui';

import 'package:flutter/material.dart';

class OrbStopButton extends StatelessWidget {
  final VoidCallback onTap;
  const OrbStopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            center: Alignment.topLeft,
            radius: 1.2,
            colors: [Color(0xFFAA6FE0), Color(0xFF7C3FBF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9B59F5).withAlpha(70),
              blurRadius: 32,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
