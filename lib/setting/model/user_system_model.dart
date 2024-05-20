// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:flutter/foundation.dart';

abstract class UserSystemModelBase {}

class UserSystenModelError extends UserSystemModelBase {
  final String message;
  UserSystenModelError({
    required this.message,
  });
}

class UserSystemModelLoading extends UserSystemModelBase {}

class UserSystemUserModel {
  final int id;
  final String? email;
  final String? profile_photo;
  final String nick_name;
  final String name;
  final String birth;
  final String gender;
  final List<UserNationalityModel> user_nationality;
  UserSystemUserModel({
    required this.id,
    this.email,
    this.profile_photo,
    required this.nick_name,
    required this.name,
    required this.birth,
    required this.gender,
    required this.user_nationality,
  });

  UserSystemUserModel copyWith({
    int? id,
    ValueGetter<String?>? email,
    ValueGetter<String?>? profile_photo,
    String? nick_name,
    String? name,
    String? birth,
    String? gender,
    List<UserNationalityModel>? user_nationality,
  }) {
    return UserSystemUserModel(
      id: id ?? this.id,
      email: email?.call() ?? this.email,
      profile_photo: profile_photo?.call() ?? this.profile_photo,
      nick_name: nick_name ?? this.nick_name,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      user_nationality: user_nationality ?? this.user_nationality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'profile_photo': profile_photo,
      'nick_name': nick_name,
      'name': name,
      'birth': birth,
      'gender': gender,
      'user_nationality': user_nationality.map((x) => x.toMap()).toList(),
    };
  }

  factory UserSystemUserModel.fromMap(Map<String, dynamic> map) {
    return UserSystemUserModel(
      id: map['id']?.toInt() ?? 0,
      email: map['email'],
      profile_photo: map['profile_photo'],
      nick_name: map['nick_name'] ?? '',
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
      user_nationality: List<UserNationalityModel>.from(
          map['user_nationality']?.map((x) => UserNationalityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSystemUserModel.fromJson(String source) =>
      UserSystemUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserSystemUserModel(id: $id, email: $email, profile_photo: $profile_photo, nick_name: $nick_name, name: $name, birth: $birth, gender: $gender, user_nationality: $user_nationality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSystemUserModel &&
        other.id == id &&
        other.email == email &&
        other.profile_photo == profile_photo &&
        other.nick_name == nick_name &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        listEquals(other.user_nationality, user_nationality);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        profile_photo.hashCode ^
        nick_name.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        user_nationality.hashCode;
  }
}

class UserSystemModel extends UserSystemModelBase {
  final String system_language;
  final bool main_alarm;
  final bool etc_alarm;
  final int id;
  final UserSystemUserModel user;
  UserSystemModel({
    required this.system_language,
    required this.main_alarm,
    required this.etc_alarm,
    required this.id,
    required this.user,
  });

  UserSystemModel copyWith({
    String? system_language,
    bool? main_alarm,
    bool? etc_alarm,
    int? id,
    UserSystemUserModel? user,
  }) {
    return UserSystemModel(
      system_language: system_language ?? this.system_language,
      main_alarm: main_alarm ?? this.main_alarm,
      etc_alarm: etc_alarm ?? this.etc_alarm,
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'system_language': system_language,
      'main_alarm': main_alarm,
      'etc_alarm': etc_alarm,
      'id': id,
      'user': user.toMap(),
    };
  }

  factory UserSystemModel.fromMap(Map<String, dynamic> map) {
    return UserSystemModel(
      system_language: map['system_language'] ?? '',
      main_alarm: map['main_alarm'] ?? false,
      etc_alarm: map['etc_alarm'] ?? false,
      id: map['id']?.toInt() ?? 0,
      user: UserSystemUserModel.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSystemModel.fromJson(String source) =>
      UserSystemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserSystemModel(system_language: $system_language, main_alarm: $main_alarm, etc_alarm: $etc_alarm, id: $id, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSystemModel &&
        other.system_language == system_language &&
        other.main_alarm == main_alarm &&
        other.etc_alarm == etc_alarm &&
        other.id == id &&
        other.user == user;
  }

  @override
  int get hashCode {
    return system_language.hashCode ^
        main_alarm.hashCode ^
        etc_alarm.hashCode ^
        id.hashCode ^
        user.hashCode;
  }
}
