import 'package:proyecto/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}
