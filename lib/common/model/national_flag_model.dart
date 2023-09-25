// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class NationalFlagModel {
  final int id;
  final String code;
  final String en_name;
  final String kr_name;
  NationalFlagModel({
    required this.id,
    required this.code,
    required this.en_name,
    required this.kr_name,
  });

  NationalFlagModel copyWith({
    int? id,
    String? code,
    String? en_name,
    String? kr_name,
  }) {
    return NationalFlagModel(
      id: id ?? this.id,
      code: code ?? this.code,
      en_name: en_name ?? this.en_name,
      kr_name: kr_name ?? this.kr_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'en_name': en_name,
      'kr_name': kr_name,
    };
  }

  factory NationalFlagModel.fromMap(Map<String, dynamic> map) {
    return NationalFlagModel(
      id: map['id']?.toInt() ?? 0,
      code: map['code'] ?? '',
      en_name: map['en_name'] ?? '',
      kr_name: map['kr_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NationalFlagModel.fromJson(String source) =>
      NationalFlagModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NationalFlagModel(id: $id, code: $code, en_name: $en_name, kr_name: $kr_name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NationalFlagModel &&
        other.id == id &&
        other.code == code &&
        other.en_name == en_name &&
        other.kr_name == kr_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ code.hashCode ^ en_name.hashCode ^ kr_name.hashCode;
  }
}
