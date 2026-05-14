import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:proyecto/core/theme/app_colors.dart';

class AudioPlayerCard extends StatefulWidget {
  final AudioPlayer player;
  final List<double> waveformBars;
  final int durationSeconds;
  const AudioPlayerCard({
    super.key,
    required this.player,
    required this.waveformBars,
    required this.durationSeconds,
  });

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  double _speed = 1.0;

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
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
          _buildTimes(),
          const SizedBox(height: 12),
          _buildWaveform(),
          const SizedBox(height: 20),
          _buildControls(),
          const SizedBox(height: 16),
          _buildSpeedControl(),
        ],
      ),
    );
  }

  Widget _buildTimes() {
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (_, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration =
            widget.player.duration ?? Duration(seconds: widget.durationSeconds);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _format(position),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            Text(
              _format(duration),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaveform() {
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (_, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = widget.player.duration ?? Duration.zero;
        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

        return SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.waveformBars.length, (i) {
              final played = i / widget.waveformBars.length < progress;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Container(
                    height: widget.waveformBars[i] * 80,
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

  Widget _buildControls() {
    return StreamBuilder<PlayerState>(
      stream: widget.player.playerStateStream,
      builder: (_, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = snapshot.data?.playing ?? false;
        final isCompleted =
            playerState?.processingState == ProcessingState.completed;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _skipButton(Icons.replay_10, () {
              widget.player.seek(
                widget.player.position - const Duration(seconds: 15),
              );
            }),
            const SizedBox(width: 24),
            _playButton(isPlaying, isCompleted),
            const SizedBox(width: 24),
            _skipButton(Icons.forward_10, () {
              widget.player.seek(
                widget.player.position + const Duration(seconds: 15),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _playButton(bool isPlaying, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          widget.player.seek(Duration.zero);
          widget.player.play();
        } else if (isPlaying) {
          widget.player.pause();
        } else {
          widget.player.play();
        }
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          isCompleted
              ? Icons.replay
              : (isPlaying ? Icons.pause : Icons.play_arrow),
          color: AppColors.purple,
          size: 28,
        ),
      ),
    );
  }

  Widget _skipButton(IconData icon, VoidCallback onTap) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [1.0, 1.5, 2.0].map((speed) {
        final isSelected = _speed == speed;
        return GestureDetector(
          onTap: () {
            setState(() => _speed = speed);
            widget.player.setSpeed(speed);
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
}
