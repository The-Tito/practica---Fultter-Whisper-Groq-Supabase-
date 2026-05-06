import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:proyecto/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:proyecto/features/auth/domain/entities/user_entity.dart';
import 'package:proyecto/features/auth/domain/usecases/login_usecase.dart';

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
  AuthState build() => AuthInitial();

  AuthRepositoryImpl get _repository =>
      AuthRepositoryImpl(MockAuthDataSource());

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    try {
      final user = await LoginUsecase(
        _repository,
      ).executeLogin(email: email, password: password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  // Login con Google
  Future<void> loginWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _repository.loginWithGoogle();
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  void resetState() => state = const AuthInitial();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
