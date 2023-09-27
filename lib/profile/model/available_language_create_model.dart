// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class AvailableLanguageCreateModel {
  final String level;
  final int language_id;
  AvailableLanguageCreateModel({
    required this.level,
    required this.language_id,
  });

  AvailableLanguageCreateModel copyWith({
    String? level,
    int? language_id,
  }) {
    return AvailableLanguageCreateModel(
      level: level ?? this.level,
      language_id: language_id ?? this.language_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
      'language_id': language_id,
    };
  }

  factory AvailableLanguageCreateModel.fromMap(Map<String, dynamic> map) {
    return AvailableLanguageCreateModel(
      level: map['level'] as String,
      language_id: map['language_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableLanguageCreateModel.fromJson(String source) =>
      AvailableLanguageCreateModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AvailableLanguageCreateModel(level: $level, language_id: $language_id)';

  @override
  bool operator ==(covariant AvailableLanguageCreateModel other) {
    if (identical(this, other)) return true;

    return other.level == level && other.language_id == language_id;
  }

  @override
  int get hashCode => level.hashCode ^ language_id.hashCode;
}
