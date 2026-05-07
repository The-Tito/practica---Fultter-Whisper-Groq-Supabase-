import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  final void Function() onTap;
  final double width;
  final double height;
  const MicButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 0.7,
            colors: [Color(0xFFF1526A), Color(0xFFF44181)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(
                0xFFF44181,
              ).withAlpha(120), // mismo color, semi-transparente
              blurRadius: 24, // qué tan difuso es el glow
              spreadRadius: 4, // qué tan lejos se expande
            ),
          ],
        ),
        child: Icon(Icons.mic_none),
      ),
    );
  }
}
