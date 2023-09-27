// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:biskit_app/profile/model/profile_model.dart';

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
  final String name;
  final String birth;
  final String gender;
  final bool is_active;
  final bool is_admin;
  final ProfileModel? profile;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.birth,
    required this.gender,
    required this.is_active,
    required this.is_admin,
    required this.profile,
  });

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? birth,
    String? gender,
    bool? is_active,
    bool? is_admin,
    ProfileModel? profile,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      is_active: is_active ?? this.is_active,
      is_admin: is_admin ?? this.is_admin,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'birth': birth,
      'gender': gender,
      'is_active': is_active,
      'is_admin': is_admin,
      'profile': profile?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      birth: map['birth'] as String,
      gender: map['gender'] as String,
      is_active: map['is_active'] as bool,
      is_admin: map['is_admin'] as bool,
      profile: map['profile'] != null
          ? ProfileModel.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, birth: $birth, gender: $gender, is_active: $is_active, is_admin: $is_admin, profile: $profile)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        other.is_active == is_active &&
        other.is_admin == is_admin &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        is_active.hashCode ^
        is_admin.hashCode ^
        profile.hashCode;
  }
}
