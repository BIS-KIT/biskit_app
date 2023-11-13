// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/user/model/user_nationality_model.dart';

class MeetUpCreatorModel {
  final int id;
  final String name;
  final String birth;
  final String gender;
  final List<UserNationalityModel> user_nationality;
  MeetUpCreatorModel({
    required this.id,
    required this.name,
    required this.birth,
    required this.gender,
    required this.user_nationality,
  });

  MeetUpCreatorModel copyWith({
    int? id,
    String? name,
    String? birth,
    String? gender,
    List<UserNationalityModel>? user_nationality,
  }) {
    return MeetUpCreatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      user_nationality: user_nationality ?? this.user_nationality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth': birth,
      'gender': gender,
      'user_nationality': user_nationality.map((x) => x.toMap()).toList(),
    };
  }

  factory MeetUpCreatorModel.fromMap(Map<String, dynamic> map) {
    return MeetUpCreatorModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
      user_nationality: List<UserNationalityModel>.from(
          map['user_nationality']?.map((x) => UserNationalityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpCreatorModel.fromJson(String source) =>
      MeetUpCreatorModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpCreatorModel(id: $id, name: $name, birth: $birth, gender: $gender, user_nationality: $user_nationality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpCreatorModel &&
        other.id == id &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        listEquals(other.user_nationality, user_nationality);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        user_nationality.hashCode;
  }
}
