// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum ChatRowType {
  message,
  notice,
  noticeOnlyMe,
  noticeOther,
  noticeJoin,
}

enum ChatMsgType {
  text,
  image,
}

class ChatMsgModel {
  final String uid;
  final String chatRowType;
  final String msg;
  final String msgType;
  final int createUserId;
  final dynamic createDate;
  final List<int> readUsers;
  ChatMsgModel({
    required this.uid,
    required this.chatRowType,
    required this.msg,
    required this.msgType,
    required this.createUserId,
    required this.createDate,
    required this.readUsers,
  });

  ChatMsgModel copyWith({
    String? uid,
    String? chatRowType,
    String? msg,
    String? msgType,
    int? createUserId,
    dynamic createDate,
    List<int>? readUsers,
  }) {
    return ChatMsgModel(
      uid: uid ?? this.uid,
      chatRowType: chatRowType ?? this.chatRowType,
      msg: msg ?? this.msg,
      msgType: msgType ?? this.msgType,
      createUserId: createUserId ?? this.createUserId,
      createDate: createDate ?? this.createDate,
      readUsers: readUsers ?? this.readUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'chatRowType': chatRowType,
      'msg': msg,
      'msgType': msgType,
      'createUserId': createUserId,
      'createDate': createDate,
      'readUsers': readUsers,
    };
  }

  factory ChatMsgModel.fromMap(Map<String, dynamic> map) {
    return ChatMsgModel(
      uid: map['uid'] ?? '',
      chatRowType: map['chatRowType'] ?? '',
      msg: map['msg'] ?? '',
      msgType: map['msgType'] ?? '',
      createUserId: map['createUserId']?.toInt() ?? 0,
      createDate: map['createDate'],
      readUsers: List<int>.from(map['readUsers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMsgModel.fromJson(String source) =>
      ChatMsgModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMsgModel(uid: $uid, chatRowType: $chatRowType, msg: $msg, msgType: $msgType, createUserId: $createUserId, createDate: $createDate, readUsers: $readUsers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMsgModel &&
        other.uid == uid &&
        other.chatRowType == chatRowType &&
        other.msg == msg &&
        other.msgType == msgType &&
        other.createUserId == createUserId &&
        other.createDate == createDate &&
        listEquals(other.readUsers, readUsers);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        chatRowType.hashCode ^
        msg.hashCode ^
        msgType.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode ^
        readUsers.hashCode;
  }
}
