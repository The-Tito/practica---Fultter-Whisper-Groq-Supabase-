import 'package:proyecto/features/auth/domain/entities/user_entity.dart';
import 'package:proyecto/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<UserEntity> executeLogin({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmail(email: email, password: password);
  }
}
