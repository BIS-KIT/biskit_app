// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class AlarmModel {
  final String title;
  final String content;
  final bool is_read;
  final int id;
  final String created_time;
  final String? obj_name;
  final int? obj_id;
  AlarmModel({
    required this.title,
    required this.content,
    required this.is_read,
    required this.id,
    required this.created_time,
    this.obj_name,
    this.obj_id,
  });

  AlarmModel copyWith({
    String? title,
    String? content,
    bool? is_read,
    int? id,
    String? created_time,
    String? obj_name,
    int? obj_id,
  }) {
    return AlarmModel(
      title: title ?? this.title,
      content: content ?? this.content,
      is_read: is_read ?? this.is_read,
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
      obj_name: obj_name ?? this.obj_name,
      obj_id: obj_id ?? this.obj_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'is_read': is_read,
      'id': id,
      'created_time': created_time,
      'obj_name': obj_name,
      'obj_id': obj_id,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      is_read: map['is_read'] ?? false,
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
      obj_name: map['obj_name'] ?? '',
      obj_id: map['obj_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlarmModel.fromJson(String source) =>
      AlarmModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AlarmModel(title: $title, content: $content, is_read: $is_read, id: $id, created_time: $created_time, obj_name: $obj_name, obj_id: $obj_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlarmModel &&
        other.title == title &&
        other.content == content &&
        other.is_read == is_read &&
        other.id == id &&
        other.created_time == created_time &&
        other.obj_name == obj_name &&
        other.obj_id == obj_id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        is_read.hashCode ^
        id.hashCode ^
        created_time.hashCode ^
        obj_name.hashCode ^
        obj_id.hashCode;
  }
}
