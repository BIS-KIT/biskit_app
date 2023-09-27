// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/profile/model/Introduction_create_model.dart';
import 'package:biskit_app/profile/model/available_language_create_model.dart';

class ProfileCreateModel {
  final String nick_name;
  final String? profile_photo;
  final List<AvailableLanguageCreateModel> available_languages;
  final List<IntroductionCreateModel> introductions;
  ProfileCreateModel({
    required this.nick_name,
    required this.profile_photo,
    required this.available_languages,
    required this.introductions,
  });

  ProfileCreateModel copyWith({
    String? nick_name,
    String? profile_photo,
    List<AvailableLanguageCreateModel>? available_languages,
    List<IntroductionCreateModel>? introductions,
  }) {
    return ProfileCreateModel(
      nick_name: nick_name ?? this.nick_name,
      profile_photo: profile_photo ?? this.profile_photo,
      available_languages: available_languages ?? this.available_languages,
      introductions: introductions ?? this.introductions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nick_name': nick_name,
      'profile_photo': profile_photo,
      'available_languages': available_languages.map((x) => x.toMap()).toList(),
      'introductions': introductions.map((x) => x.toMap()).toList(),
    };
  }

  factory ProfileCreateModel.fromMap(Map<String, dynamic> map) {
    return ProfileCreateModel(
      nick_name: map['nick_name'] as String,
      profile_photo:
          map['profile_photo'] != null ? map['profile_photo'] as String : null,
      available_languages: List<AvailableLanguageCreateModel>.from(
        (map['available_languages'] as List).map<AvailableLanguageCreateModel>(
          (x) =>
              AvailableLanguageCreateModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      introductions: List<IntroductionCreateModel>.from(
        (map['introductions'] as List).map<IntroductionCreateModel>(
          (x) => IntroductionCreateModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileCreateModel.fromJson(String source) =>
      ProfileCreateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileCreateModel(nick_name: $nick_name, profile_photo: $profile_photo, available_languages: $available_languages, introductions: $introductions)';
  }

  @override
  bool operator ==(covariant ProfileCreateModel other) {
    if (identical(this, other)) return true;

    return other.nick_name == nick_name &&
        other.profile_photo == profile_photo &&
        listEquals(other.available_languages, available_languages) &&
        listEquals(other.introductions, introductions);
  }

  @override
  int get hashCode {
    return nick_name.hashCode ^
        profile_photo.hashCode ^
        available_languages.hashCode ^
        introductions.hashCode;
  }
}
