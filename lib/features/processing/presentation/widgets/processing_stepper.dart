import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';

class ProcessingStepper extends StatefulWidget {
  final List<String> labels;
  final int currentStep;

  const ProcessingStepper({
    super.key,
    required this.labels,
    required this.currentStep,
  });

  @override
  State<ProcessingStepper> createState() => _ProcessingStepperState();
}

class _ProcessingStepperState extends State<ProcessingStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // va y viene infinitamente

    _pulseAnimation = Tween<double>(begin: 4, end: 12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(widget.labels.length * 2 - 1, (index) {
            if (index.isEven) {
              final step = index ~/ 2;
              return _buildCircle(step);
            } else {
              final step = index ~/ 2;
              return _buildConnector(step);
            }
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(widget.labels.length * 2 - 1, (index) {
            if (index.isEven) {
              final step = index ~/ 2;
              return _buildLabel(step);
            } else {
              return const Expanded(child: SizedBox());
            }
          }),
        ),
      ],
    );
  }

  Widget _buildCircle(int step) {
    final isCompleted = step < widget.currentStep;
    final isActive = step == widget.currentStep;

    // Gradiente igual al HeroRecordCard
    const gradient = LinearGradient(
      colors: [Color(0xFF9B75F6), Color(0xFF5E41DB)],
    );

    Widget circle = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: (isCompleted || isActive) ? gradient : null,
        color: (!isCompleted && !isActive) ? AppColors.surface : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textHint,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );

    // Envolver el activo con el glow pulsante
    if (isActive) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B75F6).withAlpha(150),
                blurRadius: _pulseAnimation.value,
                spreadRadius: _pulseAnimation.value / 3,
              ),
            ],
          ),
          child: child,
        ),
        child: circle,
      );
    }

    return circle;
  }

  Widget _buildConnector(int step) {
    final isCompleted = step < widget.currentStep;

    return Expanded(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  colors: [Color(0xFF9B75F6), Color(0xFF5E41DB)],
                )
              : null,
          color: isCompleted ? null : AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildLabel(int step) {
    final isActive = step == widget.currentStep;
    final isCompleted = step < widget.currentStep;

    return SizedBox(
      width: 44,
      child: Text(
        widget.labels[step],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: (isActive || isCompleted)
              ? AppColors.textPrimary
              : AppColors.textHint,
        ),
      ),
    );
  }
}
