import 'dart:convert';

class MeetUpCreatorModel {
  final int id;
  final String name;
  final String birth;
  final String gender;
  MeetUpCreatorModel({
    required this.id,
    required this.name,
    required this.birth,
    required this.gender,
  });

  MeetUpCreatorModel copyWith({
    int? id,
    String? name,
    String? birth,
    String? gender,
  }) {
    return MeetUpCreatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth': birth,
      'gender': gender,
    };
  }

  factory MeetUpCreatorModel.fromMap(Map<String, dynamic> map) {
    return MeetUpCreatorModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpCreatorModel.fromJson(String source) =>
      MeetUpCreatorModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpCreatorModel(id: $id, name: $name, birth: $birth, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpCreatorModel &&
        other.id == id &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ birth.hashCode ^ gender.hashCode;
  }
}
