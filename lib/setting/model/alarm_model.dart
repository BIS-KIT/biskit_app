// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class AlarmModel {
  final String title;
  final String content;
  final int id;
  final String created_time;
  AlarmModel({
    required this.title,
    required this.content,
    required this.id,
    required this.created_time,
  });

  AlarmModel copyWith({
    String? title,
    String? content,
    int? id,
    String? created_time,
  }) {
    return AlarmModel(
      title: title ?? this.title,
      content: content ?? this.content,
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'id': id,
      'created_time': created_time,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AlarmModel.fromJson(String source) =>
      AlarmModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AlarmModel(title: $title, content: $content, id: $id, created_time: $created_time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlarmModel &&
        other.title == title &&
        other.content == content &&
        other.id == id &&
        other.created_time == created_time;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        id.hashCode ^
        created_time.hashCode;
  }
}
