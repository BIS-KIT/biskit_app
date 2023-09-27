// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:biskit_app/profile/model/language_model.dart';

class AvailableLanguageModel {
  final int id;
  final String level;
  final LanguageModel language;
  final int profile_id;
  AvailableLanguageModel({
    required this.id,
    required this.level,
    required this.language,
    required this.profile_id,
  });

  AvailableLanguageModel copyWith({
    int? id,
    String? level,
    LanguageModel? language,
    int? profile_id,
  }) {
    return AvailableLanguageModel(
      id: id ?? this.id,
      level: level ?? this.level,
      language: language ?? this.language,
      profile_id: profile_id ?? this.profile_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'level': level,
      'language': language.toMap(),
      'profile_id': profile_id,
    };
  }

  factory AvailableLanguageModel.fromMap(Map<String, dynamic> map) {
    return AvailableLanguageModel(
      id: map['id'] as int,
      level: map['level'] as String,
      language: LanguageModel.fromMap(map['language'] as Map<String, dynamic>),
      profile_id: map['profile_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableLanguageModel.fromJson(String source) =>
      AvailableLanguageModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvailableLanguageModel(id: $id, level: $level, language: $language, profile_id: $profile_id)';
  }

  @override
  bool operator ==(covariant AvailableLanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.level == level &&
        other.language == language &&
        other.profile_id == profile_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        level.hashCode ^
        language.hashCode ^
        profile_id.hashCode;
  }
}
