// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class LanguageModel {
  final int id;
  final String kr_name;
  final String en_name;
  LanguageModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
  });

  LanguageModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['id'] as int,
      kr_name: map['kr_name'] as String,
      en_name: map['en_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LanguageModel(id: $id, kr_name: $kr_name, en_name: $en_name)';

  @override
  bool operator ==(covariant LanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name;
  }

  @override
  int get hashCode => id.hashCode ^ kr_name.hashCode ^ en_name.hashCode;
}
