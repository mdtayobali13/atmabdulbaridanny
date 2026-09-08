class AuthUserModel {
  final int? id;
  final String? name;
  final String? email;
  final List<String> permissions;
  final String? createdAt;
  final String? updatedAt;

  const AuthUserModel({
    this.id,
    this.name,
    this.email,
    this.permissions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AuthUserModel();
    return AuthUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      permissions: json['permissions'] is List
          ? (json['permissions'] as List).map((e) => e.toString()).toList()
          : const [],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'permissions': permissions,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  bool hasPermission(String permission) => permissions.contains(permission);
}

class AuthResponse {
  final String? token;
  final AuthUserModel? user;
  final String? message;

  const AuthResponse({this.token, this.user, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AuthResponse();
    return AuthResponse(
      token: json['token']?.toString(),
      user: json['user'] is Map ? AuthUserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)) : null,
      message: json['message']?.toString(),
    );
  }
}
