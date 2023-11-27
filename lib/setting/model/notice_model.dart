// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/setting/model/user_system_model.dart';

class NoticeModel {
  final String title;
  final String content;
  final int id;
  final UserSystemUserModel user;
  final String created_time;
  NoticeModel({
    required this.title,
    required this.content,
    required this.id,
    required this.user,
    required this.created_time,
  });

  NoticeModel copyWith({
    String? title,
    String? content,
    int? id,
    UserSystemUserModel? user,
    String? created_time,
  }) {
    return NoticeModel(
      title: title ?? this.title,
      content: content ?? this.content,
      id: id ?? this.id,
      user: user ?? this.user,
      created_time: created_time ?? this.created_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'id': id,
      'user': user.toMap(),
      'created_time': created_time,
    };
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      id: map['id']?.toInt() ?? 0,
      user: UserSystemUserModel.fromMap(map['user']),
      created_time: map['created_time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeModel.fromJson(String source) =>
      NoticeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoticeModel(title: $title, content: $content, id: $id, user: $user, created_time: $created_time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoticeModel &&
        other.title == title &&
        other.content == content &&
        other.id == id &&
        other.user == user &&
        other.created_time == created_time;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        id.hashCode ^
        user.hashCode ^
        created_time.hashCode;
  }
}
