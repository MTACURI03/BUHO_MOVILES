enum UserRole { visitor, publisher }

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role']}',
        orElse: () => UserRole.visitor,
      ),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isPublisher => role == UserRole.publisher;
  bool get isVisitor => role == UserRole.visitor;
}
