import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/app_bottom_nav_bar.dart';
import 'package:proyecto/core/widgets/app_google_button.dart';
import 'package:proyecto/core/widgets/app_primary_button.dart';
import 'package:proyecto/core/widgets/app_text_field.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/core/widgets/mic_button.dart';
import 'package:proyecto/features/dashboard/presentation/widgets/hero_record_card.dart';
import 'package:proyecto/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:proyecto/features/recording/presentation/widgets/orb_stop_button.dart';
import 'package:proyecto/features/recording/presentation/widgets/recording_waveform.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  double _amplitude = 0.05;
  bool _isActive = false;
  Timer? _timer;
  final _random = Random();

  void _toggleSimulation() {
    setState(() => _isActive = !_isActive);

    if (_isActive) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          // Simula voz humana: valores entre 0.2 y 0.9 con ruido
          _amplitude = 0.2 + _random.nextDouble() * 0.7;
        });
      });
    } else {
      _timer?.cancel();
      setState(() => _amplitude = 0.05);
    }
  }

  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('TextField — normal'),
            AppTextField(
              controller: _controller,
              label: 'CORREO',
              hint: 'hola@kotoba.app',
              keyboardType: TextInputType.emailAddress,
            ),
            _section('TextField — contraseña'),
            AppTextField(
              controller: _controller,
              label: 'CONTRASEÑA',
              hint: '••••••••',
              obscureText: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            _section('Botón primario'),
            AppPrimaryButton(label: 'Iniciar sesión', onPressed: () {}),
            _section('Botón Google'),
            AppGoogleButton(onPressed: () {}),
            _section('Navbar'),
            SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 2,
                    right: 70,
                    child: AppBottomNavBar(currentIndex: 0, onTap: (int p1) {}),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 0, // flota sobre el navbar
                    child: MicButton(onTap: () {}, width: 55, height: 55),
                  ),
                ],
              ),
            ),
            _section('StatCard'),
            StatCard(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.9,
                colors: [
                  Color.fromARGB(255, 91, 211, 179),
                  Color.fromRGBO(62, 168, 138, 1),
                ],
              ),
              shadow: BoxShadow(
                color: Color(
                  0xFF5BD3C5,
                ).withAlpha(60), // mismo color, semi-transparente
                blurRadius: 10, // qué tan difuso es el glow
                spreadRadius: 2, // qué tan lejos se expande
              ),
              label: 'ESTE MES',
              value: '4h 12m',
              description: 'transcritos',
            ),
            _section('Hero record'),
            HeroRecordCard(
              statusLabel: 'LISTO PARA ESCUCHAR',
              title: 'Captura tu voz.\nTe devolvemos texto.',
              onRecord: () {},
            ),
            _section('WaveForm'),
            RecordingWaveform(amplitude: _amplitude, isActive: _isActive),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleSimulation,
              child: Text(_isActive ? 'Detener' : 'Simular grabación'),
            ),
            _section('OrbButton'),
            const SizedBox(height: 40),
            OrbStopButton(onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
