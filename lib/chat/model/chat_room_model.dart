import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChatRoomFirstUserInfo {
  final int userId;
  final dynamic firstJoinDate;
  ChatRoomFirstUserInfo({
    required this.userId,
    required this.firstJoinDate,
  });

  ChatRoomFirstUserInfo copyWith({
    int? userId,
    dynamic firstJoinDate,
  }) {
    return ChatRoomFirstUserInfo(
      userId: userId ?? this.userId,
      firstJoinDate: firstJoinDate ?? this.firstJoinDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstJoinDate': firstJoinDate,
    };
  }

  factory ChatRoomFirstUserInfo.fromMap(Map<String, dynamic> map) {
    return ChatRoomFirstUserInfo(
      userId: map['userId']?.toInt() ?? 0,
      firstJoinDate: map['firstJoinDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomFirstUserInfo.fromJson(String source) =>
      ChatRoomFirstUserInfo.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChatRoomFirstUserInfo(userId: $userId, firstJoinDate: $firstJoinDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoomFirstUserInfo &&
        other.userId == userId &&
        other.firstJoinDate == firstJoinDate;
  }

  @override
  int get hashCode => userId.hashCode ^ firstJoinDate.hashCode;
}

class ChatRoomModel {
  final String uid;
  final String title;
  final List<int> joinUsers;
  final List<ChatRoomFirstUserInfo> firstUserInfoList;
  final String? roomImagePath;
  final String? lastMsgUid;
  final String? lastMsg;
  final dynamic lastMsgDate;
  final List<int> lastMsgReadUsers;
  final int createUserId;
  final dynamic createDate;
  ChatRoomModel({
    required this.uid,
    required this.title,
    required this.joinUsers,
    required this.firstUserInfoList,
    this.roomImagePath,
    this.lastMsgUid,
    this.lastMsg,
    this.lastMsgDate,
    required this.lastMsgReadUsers,
    required this.createUserId,
    required this.createDate,
  });

  ChatRoomModel copyWith({
    String? uid,
    String? title,
    List<int>? joinUsers,
    List<ChatRoomFirstUserInfo>? firstUserInfoList,
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
      joinUsers: joinUsers ?? this.joinUsers,
      firstUserInfoList: firstUserInfoList ?? this.firstUserInfoList,
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
    return {
      'uid': uid,
      'title': title,
      'joinUsers': joinUsers,
      'firstUserInfoList': firstUserInfoList.map((x) => x.toMap()).toList(),
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
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      joinUsers: List<int>.from(map['joinUsers']),
      firstUserInfoList: List<ChatRoomFirstUserInfo>.from(
          map['firstUserInfoList']
              ?.map((x) => ChatRoomFirstUserInfo.fromMap(x))),
      roomImagePath: map['roomImagePath'],
      lastMsgUid: map['lastMsgUid'],
      lastMsg: map['lastMsg'],
      lastMsgDate: map['lastMsgDate'],
      lastMsgReadUsers: List<int>.from(map['lastMsgReadUsers']),
      createUserId: map['createUserId']?.toInt() ?? 0,
      createDate: map['createDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatRoomModel(uid: $uid, title: $title, joinUsers: $joinUsers, firstUserInfoList: $firstUserInfoList, roomImagePath: $roomImagePath, lastMsgUid: $lastMsgUid, lastMsg: $lastMsg, lastMsgDate: $lastMsgDate, lastMsgReadUsers: $lastMsgReadUsers, createUserId: $createUserId, createDate: $createDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoomModel &&
        other.uid == uid &&
        other.title == title &&
        listEquals(other.joinUsers, joinUsers) &&
        listEquals(other.firstUserInfoList, firstUserInfoList) &&
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
        joinUsers.hashCode ^
        firstUserInfoList.hashCode ^
        roomImagePath.hashCode ^
        lastMsgUid.hashCode ^
        lastMsg.hashCode ^
        lastMsgDate.hashCode ^
        lastMsgReadUsers.hashCode ^
        createUserId.hashCode ^
        createDate.hashCode;
  }
}
