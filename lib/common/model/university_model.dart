// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UniversityModel {
  final int id;
  final String kr_name;
  final String en_name;
  final String campus_type;
  final String location;
  UniversityModel({
    required this.id,
    required this.kr_name,
    required this.en_name,
    required this.campus_type,
    required this.location,
  });

  UniversityModel copyWith({
    int? id,
    String? kr_name,
    String? en_name,
    String? campus_type,
    String? location,
  }) {
    return UniversityModel(
      id: id ?? this.id,
      kr_name: kr_name ?? this.kr_name,
      en_name: en_name ?? this.en_name,
      campus_type: campus_type ?? this.campus_type,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kr_name': kr_name,
      'en_name': en_name,
      'campus_type': campus_type,
      'location': location,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      id: map['id']?.toInt() ?? 0,
      kr_name: map['kr_name'] ?? '',
      en_name: map['en_name'] ?? '',
      campus_type: map['campus_type'] ?? '',
      location: map['location'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityModel.fromJson(String source) =>
      UniversityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UniversityModel(id: $id, kr_name: $kr_name, en_name: $en_name, campus_type: $campus_type, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityModel &&
        other.id == id &&
        other.kr_name == kr_name &&
        other.en_name == en_name &&
        other.campus_type == campus_type &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        kr_name.hashCode ^
        en_name.hashCode ^
        campus_type.hashCode ^
        location.hashCode;
  }
}
