// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class TopicModel {
  final int id;
  final String kr_name;
  final String en_name;
  final bool is_custom;
  final String? icon_url;
  TopicModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
    required this.is_custom,
    this.icon_url,
  });

  TopicModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
    bool? is_custom,
    String? icon_url,
  }) {
    return TopicModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
      is_custom: is_custom ?? this.is_custom,
      icon_url: icon_url ?? this.icon_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
      'is_custom': is_custom,
      'icon_url': icon_url,
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['id']?.toInt() ?? 0,
      kr_name: map['kr_name'] ?? '',
      en_name: map['en_name'] ?? '',
      is_custom: map['is_custom'] ?? false,
      icon_url: map['icon_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TopicModel.fromJson(String source) =>
      TopicModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TopicModel(id: $id, kr_name: $kr_name, en_name: $en_name, is_custom: $is_custom, icon_url: $icon_url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopicModel &&
        other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name &&
        other.is_custom == is_custom &&
        other.icon_url == icon_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        kr_name.hashCode ^
        en_name.hashCode ^
        is_custom.hashCode ^
        icon_url.hashCode;
  }
}
