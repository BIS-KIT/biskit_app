// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:biskit_app/profile/model/language_model.dart';

class AvailableLanguageModel {
  final int id;
  final String level;
  final LanguageModel language;
  AvailableLanguageModel({
    required this.id,
    required this.level,
    required this.language,
  });

  AvailableLanguageModel copyWith({
    int? id,
    String? level,
    LanguageModel? language,
  }) {
    return AvailableLanguageModel(
      id: id ?? this.id,
      level: level ?? this.level,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'level': level,
      'language': language.toMap(),
    };
  }

  factory AvailableLanguageModel.fromMap(Map<String, dynamic> map) {
    return AvailableLanguageModel(
      id: map['id'] as int,
      level: map['level'] as String,
      language: LanguageModel.fromMap(map['language'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableLanguageModel.fromJson(String source) =>
      AvailableLanguageModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvailableLanguageModel(id: $id, level: $level, language: $language)';
  }

  @override
  bool operator ==(covariant AvailableLanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.level == level && other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^ level.hashCode ^ language.hashCode;
  }
}
