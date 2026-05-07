import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/widgets/app_bottom_nav_bar.dart';
import 'package:proyecto/core/widgets/app_primary_button.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/core/widgets/mic_button.dart';
import 'package:proyecto/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthInitial) {
        context.go(AppRoutes.login);
      }
    });

    final isLoading = ref.watch(authProvider) is AuthLoading;

    return BaseScreen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AppPrimaryButton(
                  label: 'Cerrar sesión',
                  isLoading: isLoading,
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: AppBottomNavBar(
                    currentIndex: 2,
                    onTap: (int index) {
                      switch (index) {
                        case 0:
                          context.go(AppRoutes.dashboard);
                        case 1:
                          context.go(AppRoutes.library);
                        case 2:
                          context.go(AppRoutes.profile);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                MicButton(
                  onTap: () => context.go(AppRoutes.recording),
                  width: 55,
                  height: 55,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
