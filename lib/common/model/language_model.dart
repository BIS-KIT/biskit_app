import 'dart:convert';

class LanguageModel {
  final String id;
  final String name;
  LanguageModel({
    required this.id,
    required this.name,
  });

  LanguageModel copyWith({
    String? id,
    String? name,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LanguageModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant LanguageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
