// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;
  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

class UserModel extends UserModelBase {
  final int id;
  final String email;
  UserModel({
    required this.id,
    required this.email,
  });

  UserModel copyWith({
    int? id,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(id: $id, email: $email)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
