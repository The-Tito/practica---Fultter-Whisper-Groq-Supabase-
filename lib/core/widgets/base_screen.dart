import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/dot_painter.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Asegura que el contenedor sea el fondo
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 0.7,
            colors: [Color.fromARGB(102, 53, 22, 112), AppColors.background],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: DotPatternPainter(), // El painter que definimos antes
            ),
            child, // Aquí va el contenido de tu vista
          ],
        ),
      ),
    );
  }
}
