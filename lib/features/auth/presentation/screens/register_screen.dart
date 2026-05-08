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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
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
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          _buildBack(),
                          SizedBox(height: 32),
                          _buildHeader(),
                          SizedBox(height: 32),
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

  Widget _buildBack() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            appRouter.pop();
          },
          child: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crea tu cuenta.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 8),
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
          controller: _nameController,
          label: 'NOMBRE',
          hint: 'tu nombre',
          validator: (value) {
            if (value == null || value.trim().isEmpty)
              return 'Ingresa tu nombre';
            if (value.length < 2) return 'Nombre invalido';
            return null;
          },
        ),
        const SizedBox(height: 12),
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
              'Al registrarse aceptas los terminos y la Politica de privacidad',
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
          label: 'Crear Cuenta',
          isLoading: isLoading,
          onPressed: isLoading ? null : _handlerRegister,
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
      ],
    );
  }

  void _handlerRegister() {
    if (_formkey.currentState?.validate() ?? false) {
      ref
          .read(authProvider.notifier)
          .registerWithEmail(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _handleGoogleLogin() {}
}
