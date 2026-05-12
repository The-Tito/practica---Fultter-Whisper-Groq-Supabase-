import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/features/processing/presentation/widgets/processing_stepper.dart';
import 'package:proyecto/features/transcriptions/presentation/providers/processing_provider.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  final String filePath;
  final int durationSeconds;

  const ProcessingScreen({
    super.key,
    required this.filePath,
    required this.durationSeconds,
  });

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  final List<String> _stepLabels = [
    'Transcribiendo',
    'Generando título',
    'Desarrollando idea',
    'Subiendo audio',
    'Guardando',
  ];

  final Map<String, int> _stepMap = {
    'Transcribiendo audio...': 0,
    'Generando título...': 1,
    'Desarrollando tu idea...': 2,
    'Subiendo audio...': 3,
    'Guardando nota...': 4,
  };

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(processingProvider.notifier)
          .process(
            filePath: widget.filePath,
            durationSeconds: widget.durationSeconds,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(processingProvider, (_, next) {
      if (next is ProcessingStep) {
        final index = _stepMap[next.message];
        if (index != null) setState(() => _currentStep = index);
      } else if (next is ProcessingDone) {
        context.go('${AppRoutes.detail}/${next.transcriptionId}');
      }
    });

    final state = ref.watch(processingProvider);

    return BaseScreen(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildHeader(),
              const SizedBox(height: 64),
              ProcessingStepper(labels: _stepLabels, currentStep: _currentStep),
              const SizedBox(height: 32),
              _buildStatusMessage(state),
              const Spacer(),
              if (state is ProcessingError) _buildErrorActions(),
              if (state is ProcessingError) const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF9B75F6), Color(0xFF5E41DB)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B75F6).withAlpha(80),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 20),
        const Text(
          'Procesando tu idea',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'La IA está analizando tu grabación',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatusMessage(ProcessingState state) {
    if (state is ProcessingError) {
      return Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 28),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.red, fontSize: 14),
          ),
        ],
      );
    }

    final message = state is ProcessingStep ? state.message : 'Iniciando...';

    return Text(
      message,
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    );
  }

  Widget _buildErrorActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(processingProvider.notifier)
                  .process(
                    filePath: widget.filePath,
                    durationSeconds: widget.durationSeconds,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Reintentar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go(AppRoutes.dashboard),
          child: const Text(
            'Volver al inicio',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
