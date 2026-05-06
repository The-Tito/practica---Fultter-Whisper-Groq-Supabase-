import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/app_google_button.dart';
import 'package:proyecto/core/widgets/app_primary_button.dart';
import 'package:proyecto/core/widgets/app_text_field.dart';
import 'package:proyecto/core/widgets/base_screen.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
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
