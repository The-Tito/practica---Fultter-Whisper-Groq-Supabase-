import 'package:proyecto/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['user_metadata']?['full_name'] as String?,
      avatarUrl: json['user_metadata']?['avatar_url'] as String?,
    );
  }
}
