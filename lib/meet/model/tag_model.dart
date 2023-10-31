// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class TagModel {
  final int id;
  final String kr_name;
  final String en_name;
  final bool is_custom;
  TagModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
    required this.is_custom,
  });

  TagModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
    bool? is_custom,
  }) {
    return TagModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
      is_custom: is_custom ?? this.is_custom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
      'is_custom': is_custom,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id']?.toInt() ?? 0,
      kr_name: map['kr_name'] ?? '',
      en_name: map['en_name'] ?? '',
      is_custom: map['is_custom'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TagModel.fromJson(String source) =>
      TagModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TagModel(id: $id, kr_name: $kr_name, en_name: $en_name, is_custom: $is_custom)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TagModel &&
        other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name &&
        other.is_custom == is_custom;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        kr_name.hashCode ^
        en_name.hashCode ^
        is_custom.hashCode;
  }
}
