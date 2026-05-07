import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/di/injection.dart';
import 'package:proyecto/features/auth/domain/entities/user_entity.dart';
import 'package:proyecto/features/auth/domain/repositories/auth_repository.dart';

// Estado
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// Notifier
// Login con email
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  AuthRepository get _repository => getIt<AuthRepository>();

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.loginWithEmail(
        email: email,
        password: password,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    state = const AuthInitial();
  }

  void resetState() => state = const AuthInitial();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
