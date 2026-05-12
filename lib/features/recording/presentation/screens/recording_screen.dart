import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/features/recording/presentation/providers/recording_provider.dart';
import 'package:proyecto/features/recording/presentation/widgets/orb_stop_button.dart';
import 'package:proyecto/features/recording/presentation/widgets/recording_timer.dart';
import 'package:proyecto/features/recording/presentation/widgets/recording_waveform.dart';
import 'package:record/record.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(recordingProvider.notifier).startRecording();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingProvider);

    ref.listen(recordingProvider, (_, next) {
      if (next is RecordingDone) {
        context.go(
          AppRoutes.processing,
          extra: {
            'filePath': next.filePath,
            'durationSeconds': next.duration.inSeconds,
          },
        );
      }
      if (next is RecordingError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text((next).message)));
        context.go(AppRoutes.dashboard);
      }
    });

    final isRecording = recordingState is RecordingInProgress;
    final isPaused = recordingState is RecordingPaused;
    final elapsed = switch (recordingState) {
      RecordingInProgress(:final elapsed) => elapsed,
      RecordingPaused(:final elapsed) => elapsed,
      _ => Duration.zero,
    };
    final amplitude = recordingState is RecordingInProgress
        ? recordingState.amplitude
        : 0.05;
    return BaseScreen(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildTopBar(context),
              const Spacer(),
              RecordingTimer(elapsed: elapsed),
              const SizedBox(height: 8),
              Text(
                isRecording
                    ? 'Toca el cuadrado para detener'
                    : isPaused
                    ? 'Pausado'
                    : 'Iniciando...',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 48),
              RecordingWaveform(amplitude: amplitude, isActive: isRecording),
              if (recordingState is RecordingInProgress)
                Text(
                  'amp: ${(recordingState as RecordingInProgress).amplitude.toStringAsFixed(3)}',
                  style: const TextStyle(color: Colors.yellow, fontSize: 12),
                ),
              const Spacer(),
              OrbStopButton(
                onTap: () =>
                    ref.read(recordingProvider.notifier).stopRecording(),
              ),
              const Spacer(),
              _buildSecondaryButtons(context, isRecording),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(recordingProvider.notifier).reset();
            context.go(AppRoutes.dashboard);
          },
          child: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
        ),
      ],
    );
  }

  Widget _buildSecondaryButtons(BuildContext context, bool isRecording) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SecondaryButton(
          icon: isRecording ? Icons.pause : Icons.play_arrow,
          onTap: () {
            if (isRecording) {
              ref.read(recordingProvider.notifier).pauseRecording();
            } else {
              ref.read(recordingProvider.notifier).resumeRecording();
            }
          }, // próxima iteración
        ),
        const SizedBox(width: 32),
        _SecondaryButton(
          icon: Icons.delete_outline,
          onTap: () {
            ref.read(recordingProvider.notifier).reset();
            context.go(AppRoutes.dashboard);
          },
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(60),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }
}
