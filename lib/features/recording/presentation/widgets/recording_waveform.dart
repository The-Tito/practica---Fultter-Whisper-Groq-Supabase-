import 'package:flutter/material.dart';

class RecordingWaveform extends StatefulWidget {
  final double amplitude;
  final bool isActive;
  const RecordingWaveform({
    super.key,
    required this.amplitude,
    required this.isActive,
  });

  @override
  State<RecordingWaveform> createState() => _RecordingWaveformState();
}

class _RecordingWaveformState extends State<RecordingWaveform> {
  final List<double> _bars = List.filled(50, 0.05, growable: true);

  @override
  void didUpdateWidget(RecordingWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      setState(() {
        _bars.removeAt(0);
        _bars.add(widget.amplitude.clamp(0.05, 1.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_bars.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: AnimatedContainer(
                duration: const Duration(microseconds: 80),
                height: _bars[i] * 120,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(85),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
