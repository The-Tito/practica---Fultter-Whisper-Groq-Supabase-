import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:proyecto/features/auth/data/models/user_model.dart';
import 'auth_datasource.dart';

class SupabaseAuthDataSource implements AuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) throw Exception('Error al iniciar sesión');
    return UserModel.fromSupabase(response.user!);
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    if (response.user == null) throw Exception('Error al crear la cuenta');
    return UserModel.fromSupabase(response.user!);
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
