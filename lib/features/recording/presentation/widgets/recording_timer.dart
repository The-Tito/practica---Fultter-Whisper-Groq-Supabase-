import 'package:flutter/material.dart';

class RecordingTimer extends StatelessWidget {
  final Duration elapsed;

  const RecordingTimer({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final centiseconds = (elapsed.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$minutes:$seconds',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: -2,
            ),
          ),
          TextSpan(
            text: '.$centiseconds',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
