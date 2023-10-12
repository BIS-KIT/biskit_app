// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatMsgModel {
  final String uid;
  final String msg;
  final int createUserId;
  final dynamic createDate;
  final List<int> readUsers;
  final String? createUserProfilePath;
  ChatMsgModel({
    required this.uid,
    required this.msg,
    required this.createUserId,
    required this.createDate,
    required this.readUsers,
    this.createUserProfilePath,
  });

  ChatMsgModel copyWith({
    String? uid,
    String? msg,
    int? createUserId,
    dynamic createDate,
    List<int>? readUsers,
    String? createUserProfilePath,
  }) {
    return ChatMsgModel(
      uid: uid ?? this.uid,
      msg: msg ?? this.msg,
      createUserId: createUserId ?? this.createUserId,
      createDate: createDate ?? this.createDate,
      readUsers: readUsers ?? this.readUsers,
      createUserProfilePath:
          createUserProfilePath ?? this.createUserProfilePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'msg': msg,
      'createUserId': createUserId,
      'createDate': createDate,
      'readUsers': readUsers,
      'createUserProfilePath': createUserProfilePath,
    };
  }

  factory ChatMsgModel.fromMap(Map<String, dynamic> map) {
    return ChatMsgModel(
      uid: map['uid'] ?? '',
      msg: map['msg'] ?? '',
      createUserId: map['createUserId']?.toInt() ?? 0,
      createDate: map['createDate'],
      readUsers: List<int>.from(map['readUsers']),
      createUserProfilePath: map['createUserProfilePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMsgModel.fromJson(String source) =>
      ChatMsgModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMsgModel(uid: $uid, msg: $msg, createUserId: $createUserId, createDate: $createDate, readUsers: $readUsers, createUserProfilePath: $createUserProfilePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMsgModel &&
        other.uid == uid &&
        other.msg == msg &&
        other.createUserId == createUserId &&
        other.createDate == createDate &&
        listEquals(other.readUsers, readUsers) &&
        other.createUserProfilePath == createUserProfilePath;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        msg.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode ^
        readUsers.hashCode ^
        createUserProfilePath.hashCode;
  }
}
