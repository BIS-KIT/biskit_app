// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: non_constant_identifier_names

class SignUpModel {
  final String? email;
  final String? password;
  final String? name;
  final String? birth;
  final String? gender;
  final List<int>? nationality_ids;
  final int? university_id;
  final String? department;
  final String? education_status;
  final bool terms_mandatory;
  final bool terms_optional;
  final bool terms_push;
  final String? sns_type;
  final String? sns_id;
  SignUpModel({
    this.email,
    this.password,
    this.name,
    this.birth,
    this.gender,
    this.nationality_ids,
    this.university_id,
    this.department,
    this.education_status,
    this.terms_mandatory = false,
    this.terms_optional = false,
    this.terms_push = false,
    this.sns_type,
    this.sns_id,
  });

  SignUpModel copyWith({
    String? email,
    String? password,
    String? name,
    String? birth,
    String? gender,
    List<int>? nationality_ids,
    int? university_id,
    String? department,
    String? education_status,
    bool? terms_mandatory,
    bool? terms_optional,
    bool? terms_push,
    String? sns_type,
    String? sns_id,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      nationality_ids: nationality_ids ?? this.nationality_ids,
      university_id: university_id ?? this.university_id,
      department: department ?? this.department,
      education_status: education_status ?? this.education_status,
      terms_mandatory: terms_mandatory ?? this.terms_mandatory,
      terms_optional: terms_optional ?? this.terms_optional,
      terms_push: terms_push ?? this.terms_push,
      sns_type: sns_type ?? this.sns_type,
      sns_id: sns_id ?? this.sns_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'name': name,
      'birth': birth,
      'gender': gender,
      'nationality_ids': nationality_ids,
      'university_id': university_id,
      'department': department,
      'education_status': education_status,
      'terms_mandatory': terms_mandatory,
      'terms_optional': terms_optional,
      'terms_push': terms_push,
      'sns_type': sns_type,
      'sns_id': sns_id,
    };
  }

  factory SignUpModel.fromMap(Map<String, dynamic> map) {
    return SignUpModel(
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      birth: map['birth'] != null ? map['birth'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      nationality_ids: map['nationality_ids'] != null
          ? List<int>.from((map['nationality_ids'] as List<int>))
          : null,
      university_id:
          map['university_id'] != null ? map['university_id'] as int : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      education_status: map['education_status'] != null
          ? map['education_status'] as String
          : null,
      terms_mandatory: map['terms_mandatory'] as bool,
      terms_optional: map['terms_optional'] as bool,
      terms_push: map['terms_push'] as bool,
      sns_type: map['sns_type'] != null ? map['sns_type'] as String : null,
      sns_id: map['sns_id'] != null ? map['sns_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpModel.fromJson(String source) =>
      SignUpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignUpModel(email: $email, password: $password, name: $name, birth: $birth, gender: $gender, nationality_ids: $nationality_ids, university_id: $university_id, department: $department, education_status: $education_status, terms_mandatory: $terms_mandatory, terms_optional: $terms_optional, terms_push: $terms_push, sns_type: $sns_type, sns_id: $sns_id)';
  }

  @override
  bool operator ==(covariant SignUpModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        listEquals(other.nationality_ids, nationality_ids) &&
        other.university_id == university_id &&
        other.department == department &&
        other.education_status == education_status &&
        other.terms_mandatory == terms_mandatory &&
        other.terms_optional == terms_optional &&
        other.terms_push == terms_push &&
        other.sns_type == sns_type &&
        other.sns_id == sns_id;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        nationality_ids.hashCode ^
        university_id.hashCode ^
        department.hashCode ^
        education_status.hashCode ^
        terms_mandatory.hashCode ^
        terms_optional.hashCode ^
        terms_push.hashCode ^
        sns_type.hashCode ^
        sns_id.hashCode;
  }
}
