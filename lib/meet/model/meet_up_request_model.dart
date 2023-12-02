// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/user/model/user_model.dart';

class MeetUpRequestModel {
  final UserModel user;
  final int meeting_id;
  final String status;
  final int id;
  final String created_time;

  MeetUpRequestModel({
    required this.user,
    required this.meeting_id,
    required this.status,
    required this.id,
    required this.created_time,
  });

  MeetUpRequestModel copyWith({
    UserModel? user,
    int? meeting_id,
    String? status,
    int? id,
    String? created_time,
  }) {
    return MeetUpRequestModel(
      user: user ?? this.user,
      meeting_id: meeting_id ?? this.meeting_id,
      status: status ?? this.status,
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'meeting_id': meeting_id,
      'status': status,
      'id': id,
      'created_time': created_time,
    };
  }

  factory MeetUpRequestModel.fromMap(Map<String, dynamic> map) {
    return MeetUpRequestModel(
      user: UserModel.fromMap(map['user']),
      meeting_id: map['meeting_id']?.toInt() ?? 0,
      status: map['status'] ?? '',
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpRequestModel.fromJson(String source) =>
      MeetUpRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpRequestModel(user: $user, meeting_id: $meeting_id, status: $status, id: $id, created_time: $created_time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpRequestModel &&
        other.user == user &&
        other.meeting_id == meeting_id &&
        other.status == status &&
        other.id == id &&
        other.created_time == created_time;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        meeting_id.hashCode ^
        status.hashCode ^
        id.hashCode ^
        created_time.hashCode;
  }
}
