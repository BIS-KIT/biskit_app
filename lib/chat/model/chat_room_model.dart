import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatRoomModel {
  final String uid;
  final String title;
  final List<int> users;
  final String? roomImagePath;
  final String? lastMsgUid;
  final String? lastMsg;
  final dynamic lastMsgDate;
  final int createUserId;
  final dynamic createDate;
  ChatRoomModel({
    required this.uid,
    required this.title,
    required this.users,
    this.roomImagePath,
    this.lastMsgUid,
    this.lastMsg,
    this.lastMsgDate,
    required this.createUserId,
    required this.createDate,
  });

  ChatRoomModel copyWith({
    String? uid,
    String? title,
    List<int>? users,
    String? roomImagePath,
    String? lastMsgUid,
    String? lastMsg,
    dynamic lastMsgDate,
    int? createUserId,
    dynamic createDate,
  }) {
    return ChatRoomModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      users: users ?? this.users,
      roomImagePath: roomImagePath ?? this.roomImagePath,
      lastMsgUid: lastMsgUid ?? this.lastMsgUid,
      lastMsg: lastMsg ?? this.lastMsg,
      lastMsgDate: lastMsgDate ?? this.lastMsgDate,
      createUserId: createUserId ?? this.createUserId,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'users': users,
      'roomImagePath': roomImagePath,
      'lastMsgUid': lastMsgUid,
      'lastMsg': lastMsg,
      'lastMsgDate': lastMsgDate,
      'createUserId': createUserId,
      'createDate': createDate,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      users: List<int>.from(map['users']),
      roomImagePath: map['roomImagePath'],
      lastMsgUid: map['lastMsgUid'],
      lastMsg: map['lastMsg'],
      lastMsgDate: map['lastMsgDate'],
      createUserId: map['createUserId']?.toInt() ?? 0,
      createDate: map['createDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatRoomModel(uid: $uid, title: $title, users: $users, roomImagePath: $roomImagePath, lastMsgUid: $lastMsgUid, lastMsg: $lastMsg, lastMsgDate: $lastMsgDate, createUserId: $createUserId, createDate: $createDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoomModel &&
        other.uid == uid &&
        other.title == title &&
        listEquals(other.users, users) &&
        other.roomImagePath == roomImagePath &&
        other.lastMsgUid == lastMsgUid &&
        other.lastMsg == lastMsg &&
        other.lastMsgDate == lastMsgDate &&
        other.createUserId == createUserId &&
        other.createDate == createDate;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        title.hashCode ^
        users.hashCode ^
        roomImagePath.hashCode ^
        lastMsgUid.hashCode ^
        lastMsg.hashCode ^
        lastMsgDate.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode;
  }
}
