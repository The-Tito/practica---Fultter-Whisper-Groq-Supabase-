import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Gradient gradient;
  final BoxShadow shadow;
  final String label;
  final String value;
  final String description;
  const StatCard({
    super.key,
    required this.gradient,
    required this.label,
    required this.value,
    required this.description,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: gradient,
        boxShadow: [shadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Colors.white)),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
