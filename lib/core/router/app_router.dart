import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/playground/playground_screen.dart';
import 'package:proyecto/features/auth/presentation/screens/login_screen.dart';
import 'package:proyecto/features/auth/presentation/screens/register_screen.dart';
import 'package:proyecto/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:proyecto/features/processing/presentation/screens/processing_screen.dart';
import 'package:proyecto/features/profile/presentation/screens/profile_screen.dart';
import 'package:proyecto/features/recording/presentation/screens/recording_screen.dart';
import 'package:proyecto/features/transcriptions/presentation/screens/library_screen.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const recording = '/recording';
  static const library = '/library';
  static const profile = '/profile';
  static const playground = '/playground';
  static const processing = '/processing';
  static const detail = '/detail';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 150),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 150),
      ),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 150),
      ),
    ),
    GoRoute(
      path: AppRoutes.recording,
      builder: (context, state) => const RecordingScreen(),
    ),
    GoRoute(
      path: AppRoutes.library,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LibraryScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 150),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 150),
      ),
    ),
    GoRoute(
      path: AppRoutes.playground,
      builder: (context, state) => const PlaygroundScreen(),
    ),

    GoRoute(
      path: AppRoutes.processing,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ProcessingScreen(
          filePath: extra['filePath'] as String,
          durationSeconds: extra['durationSeconds'] as int,
        );
      },
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'ID: ${state.pathParameters['id']!}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  ],
);
