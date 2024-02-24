// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class TagModel {
  final int id;
  final String kr_name;
  final String en_name;
  final bool is_custom;
  final String icon;
  TagModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
    required this.is_custom,
    required this.icon,
  });

  TagModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
    bool? is_custom,
    String? icon,
  }) {
    return TagModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
      is_custom: is_custom ?? this.is_custom,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
      'is_custom': is_custom,
      'icon': icon,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id']?.toInt() ?? 0,
      kr_name: map['kr_name'] ?? '',
      en_name: map['en_name'] ?? '',
      is_custom: map['is_custom'] ?? false,
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TagModel.fromJson(String source) =>
      TagModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TagModel(id: $id, kr_name: $kr_name, en_name: $en_name, is_custom: $is_custom, icon: $icon,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TagModel &&
        other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name &&
        other.is_custom == is_custom &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        kr_name.hashCode ^
        en_name.hashCode ^
        is_custom.hashCode ^
        icon.hashCode;
  }
}
