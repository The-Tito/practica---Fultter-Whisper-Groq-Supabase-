import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/mic_button.dart';

class HeroRecordCard extends StatelessWidget {
  final String statusLabel;
  final String title;
  final VoidCallback onRecord;

  const HeroRecordCard({
    super.key,
    required this.statusLabel,
    required this.title,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 2,
          colors: [Color(0xFF9B75F6), Color(0xFF5E41DB)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(
              0xFF9B75F6,
            ).withAlpha(60), // mismo color, semi-transparente
            blurRadius: 10, // qué tan difuso es el glow
            spreadRadius: 2, // qué tan lejos se expande
          ),
        ],
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(55),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // titulo
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  MicButton(onTap: onRecord, width: 40, height: 40),
                  SizedBox(width: 8),
                  Text(
                    'Grabar audio',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
