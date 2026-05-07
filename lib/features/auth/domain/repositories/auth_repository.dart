import 'package:proyecto/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}
