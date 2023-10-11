import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChatRoomModel {
  final String uid;
  final String title;
  final List<int> users;
  final String? roomImagePath;
  final String? lastMsgUid;
  final String? lastMsg;
  final dynamic lastMsgDate;
  final List<int>? lastMsgReadUsers;
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
    this.lastMsgReadUsers,
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
    List<int>? lastMsgReadUsers,
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
      lastMsgReadUsers: lastMsgReadUsers ?? this.lastMsgReadUsers,
      createUserId: createUserId ?? this.createUserId,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'users': users,
      'roomImagePath': roomImagePath,
      'lastMsgUid': lastMsgUid,
      'lastMsg': lastMsg,
      'lastMsgDate': lastMsgDate,
      'lastMsgReadUsers': lastMsgReadUsers,
      'createUserId': createUserId,
      'createDate': createDate,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      uid: map['uid'] as String,
      title: map['title'] as String,
      users: List.from((map['users'] as List)),
      roomImagePath:
          map['roomImagePath'] != null ? map['roomImagePath'] as String : null,
      lastMsgUid:
          map['lastMsgUid'] != null ? map['lastMsgUid'] as String : null,
      lastMsg: map['lastMsg'] != null ? map['lastMsg'] as String : null,
      lastMsgDate: map['lastMsgDate'] as dynamic,
      lastMsgReadUsers: map['lastMsgReadUsers'] != null
          ? List.from((map['lastMsgReadUsers'] as List))
          : null,
      createUserId: map['createUserId'] as int,
      createDate: map['createDate'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatRoomModel(uid: $uid, title: $title, users: $users, roomImagePath: $roomImagePath, lastMsgUid: $lastMsgUid, lastMsg: $lastMsg, lastMsgDate: $lastMsgDate, lastMsgReadUsers: $lastMsgReadUsers, createUserId: $createUserId, createDate: $createDate)';
  }

  @override
  bool operator ==(covariant ChatRoomModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        listEquals(other.users, users) &&
        other.roomImagePath == roomImagePath &&
        other.lastMsgUid == lastMsgUid &&
        other.lastMsg == lastMsg &&
        other.lastMsgDate == lastMsgDate &&
        listEquals(other.lastMsgReadUsers, lastMsgReadUsers) &&
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
        lastMsgReadUsers.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode;
  }
}
