import 'package:proyecto/features/auth/data/datasources/auth_datasource.dart';
import 'package:proyecto/features/auth/domain/entities/user_entity.dart';
import 'package:proyecto/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource.loginWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<UserEntity> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<void> logout() async {
    await _authDataSource.logout();
  }
}
