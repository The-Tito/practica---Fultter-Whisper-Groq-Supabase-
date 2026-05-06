import 'package:proyecto/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  });

  // implementacion futura
  Future<UserEntity> loginWithGoogle();
  Future<void> logout();
}
