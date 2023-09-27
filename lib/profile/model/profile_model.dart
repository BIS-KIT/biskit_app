// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/profile/model/introduction_model.dart';

class ProfileModel {
  final int id;
  final int user_id;
  final String nick_name;
  final String? profile_photo;
  final List<AvailableLanguageModel> available_languages;
  final List<IntroductionModel> introductions;
  ProfileModel({
    required this.id,
    required this.user_id,
    required this.nick_name,
    required this.profile_photo,
    required this.available_languages,
    required this.introductions,
  });

  ProfileModel copyWith({
    int? id,
    int? user_id,
    String? nick_name,
    String? profile_photo,
    List<AvailableLanguageModel>? available_languages,
    List<IntroductionModel>? introductions,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      nick_name: nick_name ?? this.nick_name,
      profile_photo: profile_photo ?? this.profile_photo,
      available_languages: available_languages ?? this.available_languages,
      introductions: introductions ?? this.introductions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'nick_name': nick_name,
      'profile_photo': profile_photo,
      'available_languages': available_languages.map((x) => x.toMap()).toList(),
      'introductions': introductions.map((x) => x.toMap()).toList(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as int,
      user_id: map['user_id'] as int,
      nick_name: map['nick_name'] as String,
      profile_photo:
          map['profile_photo'] != null ? map['profile_photo'] as String : null,
      available_languages: List<AvailableLanguageModel>.from(
        (map['available_languages'] as List).map<AvailableLanguageModel>(
          (x) => AvailableLanguageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      introductions: List<IntroductionModel>.from(
        (map['introductions'] as List).map<IntroductionModel>(
          (x) => IntroductionModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(id: $id, user_id: $user_id, nick_name: $nick_name, profile_photo: $profile_photo, available_languages: $available_languages, introductions: $introductions)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.nick_name == nick_name &&
        other.profile_photo == profile_photo &&
        listEquals(other.available_languages, available_languages) &&
        listEquals(other.introductions, introductions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        nick_name.hashCode ^
        profile_photo.hashCode ^
        available_languages.hashCode ^
        introductions.hashCode;
  }
}
