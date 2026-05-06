import 'package:go_router/go_router.dart';
import 'package:proyecto/core/widgets/playground/playground_screen.dart';
import 'package:proyecto/features/auth/presentation/screens/login_screen.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const recording = '/recording';
  static const processing = '/processing';
  static const library = '/library';
  static const detail = '/detail/:id';
  static const profile = '/profile';
  static const playground = '/playground';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  // redirect: _authGuard <- cuanto ya tengamos auth
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.playground,
      builder: (context, state) => const PlaygroundScreen(),
    ),
    // Aqui se ira agregando todas las rutas ->
  ],
);
