// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserUniversityModel {
  final int id;
  final String department;
  final String education_status;
  final int user_id;
  final UniversityModel university;
  UserUniversityModel({
    required this.id,
    required this.department,
    required this.education_status,
    required this.user_id,
    required this.university,
  });

  UserUniversityModel copyWith({
    int? id,
    String? department,
    String? education_status,
    int? user_id,
    UniversityModel? university,
  }) {
    return UserUniversityModel(
      id: id ?? this.id,
      department: department ?? this.department,
      education_status: education_status ?? this.education_status,
      user_id: user_id ?? this.user_id,
      university: university ?? this.university,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'education_status': education_status,
      'user_id': user_id,
      'university': university.toMap(),
    };
  }

  factory UserUniversityModel.fromMap(Map<String, dynamic> map) {
    return UserUniversityModel(
      id: map['id']?.toInt() ?? 0,
      department: map['department'] ?? '',
      education_status: map['education_status'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      university: UniversityModel.fromMap(map['university']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserUniversityModel.fromJson(String source) =>
      UserUniversityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserUniversityModel(id: $id, department: $department, education_status: $education_status, user_id: $user_id, university: $university)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserUniversityModel &&
        other.id == id &&
        other.department == department &&
        other.education_status == education_status &&
        other.user_id == user_id &&
        other.university == university;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        department.hashCode ^
        education_status.hashCode ^
        user_id.hashCode ^
        university.hashCode;
  }
}

class UniversityModel {
  final int id;
  final String kr_name;
  final String en_name;
  UniversityModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
  });

  UniversityModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
  }) {
    return UniversityModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      id: map['id']?.toInt() ?? 0,
      kr_name: map['kr_name'] ?? '',
      en_name: map['en_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityModel.fromJson(String source) =>
      UniversityModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniversityModel(id: $id, kr_name: $kr_name, en_name: $en_name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityModel &&
        other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name;
  }

  @override
  int get hashCode => id.hashCode ^ kr_name.hashCode ^ en_name.hashCode;
}
