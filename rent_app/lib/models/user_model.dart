// ignore: file_names
class User {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl; // Optional
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    required this.createdAt,
  });
}
