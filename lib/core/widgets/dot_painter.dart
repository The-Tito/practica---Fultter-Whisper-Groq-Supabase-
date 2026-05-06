import 'package:flutter/material.dart';

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
          .withValues(alpha: 0.1) // Color y transparencia de los puntos
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const double spacing = 20.0; // Espacio entre puntos

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
