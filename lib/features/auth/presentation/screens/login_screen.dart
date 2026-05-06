import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/app_google_button.dart';
import 'package:proyecto/core/widgets/app_primary_button.dart';
import 'package:proyecto/core/widgets/app_text_field.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        context.go(AppRoutes.dashboard);
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authProvider.notifier).resetState();
      }
    });
    final isLoading = ref.watch(authProvider) is AuthLoading;

    return BaseScreen(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildLogo(),
                          const SizedBox(height: 48),
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildForm(),
                          const Spacer(),
                          _buildActions(isLoading),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.purple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.graphic_eq_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kotoba',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'by Practica',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenido de\nvuelta.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Convierte tu voz en palabras que importan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AppTextField(
          controller: _emailController,
          label: 'CORREO',
          hint: 'hola@kotoba.app',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty)
              return 'Ingresa tu correo';
            if (!value.contains('@')) return 'Correo inválido';
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _passwordController,
          label: 'CONTRASEÑA',
          hint: '••••••••',
          obscureText: _obscurePassword,
          suffix: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
            if (value.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(bool isLoading) {
    return Column(
      children: [
        AppPrimaryButton(
          label: 'Iniciar sesión',
          isLoading: isLoading,
          onPressed: isLoading ? null : _handleLogin,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'o continúa con',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.divider)),
          ],
        ),
        const SizedBox(height: 20),
        AppGoogleButton(onPressed: isLoading ? null : _handleGoogleLogin),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿No tienes cuenta?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: const Text(
                'Regístrate',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formkey.currentState?.validate() ?? false) {
      ref
          .read(authProvider.notifier)
          .loginWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _handleGoogleLogin() {
    ref.read(authProvider.notifier).loginWithGoogle();
  }
}
