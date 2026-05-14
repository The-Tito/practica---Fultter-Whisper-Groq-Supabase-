import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/features/transcriptions/presentation/providers/detail_provider.dart';
import 'package:proyecto/features/transcriptions/presentation/widgets/audio_player_card.dart';
import 'package:proyecto/features/transcriptions/presentation/widgets/detail_header.dart';

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
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeader(
              title: state.title,
              createdAt: state.createdAt,
              durationSeconds: state.durationSeconds,
              onBack: () => context.pop(),
            ),
            AudioPlayerCard(
              player: _player,
              waveformBars: _waveformBars,
              durationSeconds: state.durationSeconds,
            ),
            _buildTabBar(),
            _buildTabContent(state),
          ],
        ),
      ),
    );
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
    return AnimatedBuilder(
      animation: _tabController,
      builder: (_, __) {
        final text = _tabController.index == 0
            ? state.transcript
            : state.aiContent;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        );
      },
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
