class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });
}
