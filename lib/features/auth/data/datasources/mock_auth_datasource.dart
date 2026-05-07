// import '../models/user_model.dart';
// import 'auth_datasource.dart';

// class MockAuthDatasource implements AuthDataSource {
//   @override
//   Future<UserModel> loginWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     // Simulamos latencia de red
//     await Future.delayed(const Duration(seconds: 2));

//     if (email == 'test@kotoba.app' && password == '123456') {
//       return const UserModel(
//         id: 'mock-user-1',
//         email: 'test@kotoba.app',
//         name: 'Usuario Test',
//       );
//     }

//     throw Exception('Correo o contraseña incorrectos');
//   }

//   @override
//   Future<UserModel> loginWithGoogle() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return const UserModel(
//       id: 'mock-google-1',
//       email: 'google@kotoba.app',
//       name: 'Google User',
//     );
//   }

//   @override
//   Future<void> logout() async {}
// }
