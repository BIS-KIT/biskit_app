// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/common/model/national_flag_model.dart';

class UserNationalityModel {
  final int id;
  final NationalFlagModel nationality;
  final int user_id;
  UserNationalityModel({
    required this.id,
    required this.nationality,
    required this.user_id,
  });

  UserNationalityModel copyWith({
    int? id,
    NationalFlagModel? nationality,
    int? user_id,
  }) {
    return UserNationalityModel(
      id: id ?? this.id,
      nationality: nationality ?? this.nationality,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationality': nationality.toMap(),
      'user_id': user_id,
    };
  }

  factory UserNationalityModel.fromMap(Map<String, dynamic> map) {
    return UserNationalityModel(
      id: map['id']?.toInt() ?? 0,
      nationality: NationalFlagModel.fromMap(map['nationality']),
      user_id: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserNationalityModel.fromJson(String source) =>
      UserNationalityModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserNationalityModel(id: $id, nationality: $nationality, user_id: $user_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserNationalityModel &&
        other.id == id &&
        other.nationality == nationality &&
        other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ nationality.hashCode ^ user_id.hashCode;
}
