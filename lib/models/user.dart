import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String displayName;
  final String role; // admin, editor, user
  final List<String> favorites;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = 'user',
    this.favorites = const [],
    required this.createdAt,
    this.lastLogin,
  });

  bool get isAdmin => role == 'admin';
  bool get isEditor => role == 'editor' || role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role,
      'favorites': favorites,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'user',
      favorites: List<String>.from(map['favorites'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User.fromMap(doc.data() as Map<String, dynamic>);
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
    List<String>? favorites,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
