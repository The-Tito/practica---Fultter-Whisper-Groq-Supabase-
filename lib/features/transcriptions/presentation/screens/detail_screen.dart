import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/features/transcriptions/presentation/providers/detail_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String transcriptionId;

  const DetailScreen({super.key, required this.transcriptionId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen>
    with SingleTickerProviderStateMixin {
  List<double> _waveformBars = [];
  final AudioPlayer _player = AudioPlayer();
  late TabController _tabController;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _waveformBars = List.generate(50, (_) => 0.1 + random.nextDouble() * 0.9);
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(detailProvider.notifier).load(widget.transcriptionId);
    });

    ref.listenManual(detailProvider, (_, next) {
      if (next is DetailLoaded) {
        _initPlayer(next.audioUrl);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initPlayer(String audioUrl) async {
    await _player.setUrl(audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailProvider);
    return BaseScreen(
      child: switch (state) {
        DetailLoading() => const Center(
          child: CircularProgressIndicator(color: AppColors.purpleLight),
        ),
        DetailError(:final message) => _buildError(message),
        DetailLoaded() => _buildContent(state),
      },
    );
  }

  Widget _buildContent(DetailLoaded state) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(state), // título, fecha, duración
          _buildPlayer(state), // reproductor con waveform
          _buildTabBar(), // Transcripción | Resumen IA
          Expanded(
            child: _buildTabContent(state), // contenido de la pestaña activa
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return StreamBuilder<Duration>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = _player.duration ?? Duration.zero;
        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

        return SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_waveformBars.length, (i) {
              // ¿Esta barra ya fue "reproducida"?
              final played = i / _waveformBars.length < progress;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Container(
                    height: _waveformBars[i] * 80,
                    decoration: BoxDecoration(
                      color: played ? Colors.white : Colors.white.withAlpha(60),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildPlayer(DetailLoaded state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 2,
          colors: [Color(0xFF9B75F6), Color(0xFF5E41DB)],
        ),
      ),
      child: Column(
        children: [
          // Tiempos arriba del waveform
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration =
                  _player.duration ?? Duration(seconds: state.durationSeconds);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          // Waveform
          _buildWaveform(),
          const SizedBox(height: 20),

          // Controles: -15s | play/pause | +15s
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSkipButton(Icons.replay_10, () {
                    final pos = _player.position;
                    _player.seek(pos - const Duration(seconds: 15));
                  }),
                  const SizedBox(width: 24),
                  _buildPlayButton(isPlaying),
                  const SizedBox(width: 24),
                  _buildSkipButton(Icons.forward_10, () {
                    final pos = _player.position;
                    _player.seek(pos + const Duration(seconds: 15));
                  }),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Velocidad
          _buildSpeedControl(),
        ],
      ),
    );
  }

  Widget _buildPlayButton(bool isPlaying) {
    return GestureDetector(
      onTap: () => isPlaying ? _player.pause() : _player.play(),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppColors.purple,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildSkipButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(40),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSpeedControl() {
    final speeds = [1.0, 1.5, 2.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: speeds.map((speed) {
        final isSelected = _playbackSpeed == speed;
        return GestureDetector(
          onTap: () {
            setState(() => _playbackSpeed = speed);
            _player.setSpeed(speed);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withAlpha(60)
                  : Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${speed}x',
              style: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper para formatear duración
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildHeader(DetailLoaded state) {
    final date = state.createdAt;
    final dateStr =
        '${date.day} ${_monthName(date.month)} · '
        '${_formatDuration(Duration(seconds: state.durationSeconds))}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Botón back
          GestureDetector(
            onTap: () => appRouter.pop(),
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[month];
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.background,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Transcripción'),
            Tab(text: 'Resumen IA'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(DetailLoaded state) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Pestaña 1 — Transcripción
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            state.transcript,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),

        // Pestaña 2 — Resumen IA
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            state.aiContent,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => ref
                  .read(detailProvider.notifier)
                  .load(widget.transcriptionId),
              child: const Text(
                'Reintentar',
                style: TextStyle(color: AppColors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
