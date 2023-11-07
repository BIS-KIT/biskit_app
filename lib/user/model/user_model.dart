// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/profile/model/profile_model.dart';
import 'package:biskit_app/user/model/user_nationality_model.dart';
import 'package:biskit_app/user/model/user_university_model.dart';

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
  final String? email;
  final String name;
  final String birth;
  final String gender;
  final bool is_active;
  final bool is_admin;
  final String? sns_type;
  final String? sns_id;
  final ProfileModel? profile;
  final List<UserUniversityModel> user_university;
  final List<UserNationalityModel> user_nationality;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.birth,
    required this.gender,
    required this.is_active,
    required this.is_admin,
    this.sns_type,
    this.sns_id,
    required this.profile,
    required this.user_university,
    required this.user_nationality,
  });

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? birth,
    String? gender,
    bool? is_active,
    bool? is_admin,
    String? sns_type,
    String? sns_id,
    ProfileModel? profile,
    List<UserUniversityModel>? user_university,
    List<UserNationalityModel>? user_nationality,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      is_active: is_active ?? this.is_active,
      is_admin: is_admin ?? this.is_admin,
      sns_type: sns_type ?? this.sns_type,
      sns_id: sns_id ?? this.sns_id,
      profile: profile ?? this.profile,
      user_university: user_university ?? this.user_university,
      user_nationality: user_nationality ?? this.user_nationality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birth': birth,
      'gender': gender,
      'is_active': is_active,
      'is_admin': is_admin,
      'sns_type': sns_type,
      'sns_id': sns_id,
      'profile': profile?.toMap(),
      'user_university': user_university.map((x) => x.toMap()).toList(),
      'user_nationality': user_nationality.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      email: map['email'],
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
      is_active: map['is_active'] ?? false,
      is_admin: map['is_admin'] ?? false,
      sns_type: map['sns_type'],
      sns_id: map['sns_id'],
      profile:
          map['profile'] != null ? ProfileModel.fromMap(map['profile']) : null,
      user_university: List<UserUniversityModel>.from(
          map['user_university']?.map((x) => UserUniversityModel.fromMap(x))),
      user_nationality: List<UserNationalityModel>.from(
          map['user_nationality']?.map((x) => UserNationalityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, birth: $birth, gender: $gender, is_active: $is_active, is_admin: $is_admin, sns_type: $sns_type, sns_id: $sns_id, profile: $profile, user_university: $user_university, user_nationality: $user_nationality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        other.is_active == is_active &&
        other.is_admin == is_admin &&
        other.sns_type == sns_type &&
        other.sns_id == sns_id &&
        other.profile == profile &&
        listEquals(other.user_university, user_university) &&
        listEquals(other.user_nationality, user_nationality);
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
        sns_type.hashCode ^
        sns_id.hashCode ^
        profile.hashCode ^
        user_university.hashCode ^
        user_nationality.hashCode;
  }
}
