// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatMsgModel {
  final String uid;
  final String msg;
  final int createUserId;
  final dynamic createDate;
  final List<int> readUsers;
  ChatMsgModel({
    required this.uid,
    required this.msg,
    required this.createUserId,
    required this.createDate,
    required this.readUsers,
  });

  ChatMsgModel copyWith({
    String? uid,
    String? msg,
    int? createUserId,
    dynamic createDate,
    List<int>? readUsers,
  }) {
    return ChatMsgModel(
      uid: uid ?? this.uid,
      msg: msg ?? this.msg,
      createUserId: createUserId ?? this.createUserId,
      createDate: createDate ?? this.createDate,
      readUsers: readUsers ?? this.readUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'msg': msg,
      'createUserId': createUserId,
      'createDate': createDate,
      'readUsers': readUsers,
    };
  }

  factory ChatMsgModel.fromMap(Map<String, dynamic> map) {
    return ChatMsgModel(
      uid: map['uid'] as String,
      msg: map['msg'] as String,
      createUserId: map['createUserId'] as int,
      createDate: map['createDate'] as dynamic,
      readUsers: List.from((map['readUsers'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMsgModel.fromJson(String source) =>
      ChatMsgModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMsgModel(uid: $uid, msg: $msg, createUserId: $createUserId, createDate: $createDate, readUsers: $readUsers)';
  }

  @override
  bool operator ==(covariant ChatMsgModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.msg == msg &&
        other.createUserId == createUserId &&
        other.createDate == createDate &&
        listEquals(other.readUsers, readUsers);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        msg.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode ^
        readUsers.hashCode;
  }
}
