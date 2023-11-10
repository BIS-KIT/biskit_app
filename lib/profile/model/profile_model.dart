// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/profile/model/introduction_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/user/model/user_university_model.dart';

class ProfileModel {
  final int id;
  final int user_id;
  final String nick_name;
  final String? profile_photo;
  final List<AvailableLanguageModel> available_languages;
  final List<IntroductionModel> introductions;
  final UserUniversityModel user_university;
  final StudentVerificationModel? student_verification;
  ProfileModel({
    required this.id,
    required this.user_id,
    required this.nick_name,
    required this.profile_photo,
    required this.available_languages,
    required this.introductions,
    required this.user_university,
    required this.student_verification,
  });

  ProfileModel copyWith({
    int? id,
    int? user_id,
    String? nick_name,
    String? profile_photo,
    List<AvailableLanguageModel>? available_languages,
    List<IntroductionModel>? introductions,
    UserUniversityModel? user_university,
    StudentVerificationModel? student_verification,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      nick_name: nick_name ?? this.nick_name,
      profile_photo: profile_photo ?? this.profile_photo,
      available_languages: available_languages ?? this.available_languages,
      introductions: introductions ?? this.introductions,
      user_university: user_university ?? this.user_university,
      student_verification: student_verification ?? this.student_verification,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'nick_name': nick_name,
      'profile_photo': profile_photo,
      'available_languages': available_languages.map((x) => x.toMap()).toList(),
      'introductions': introductions.map((x) => x.toMap()).toList(),
      'user_university': user_university.toMap(),
      'student_verification': student_verification?.toMap(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toInt() ?? 0,
      user_id: map['user_id']?.toInt() ?? 0,
      nick_name: map['nick_name'] ?? '',
      profile_photo: map['profile_photo'],
      available_languages: List<AvailableLanguageModel>.from(
          map['available_languages']
              ?.map((x) => AvailableLanguageModel.fromMap(x))),
      introductions: List<IntroductionModel>.from(
          map['introductions']?.map((x) => IntroductionModel.fromMap(x))),
      user_university: UserUniversityModel.fromMap(map['user_university']),
      student_verification: map['student_verification'] != null
          ? StudentVerificationModel.fromMap(map['student_verification'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, user_id: $user_id, nick_name: $nick_name, profile_photo: $profile_photo, available_languages: $available_languages, introductions: $introductions, user_university: $user_university, student_verification: $student_verification)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.user_id == user_id &&
        other.nick_name == nick_name &&
        other.profile_photo == profile_photo &&
        listEquals(other.available_languages, available_languages) &&
        listEquals(other.introductions, introductions) &&
        other.user_university == user_university &&
        other.student_verification == student_verification;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        nick_name.hashCode ^
        profile_photo.hashCode ^
        available_languages.hashCode ^
        introductions.hashCode ^
        user_university.hashCode ^
        student_verification.hashCode;
  }
}
