// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/user/model/user_model.dart';

class MeetUpRequestModel {
  final UserModel user;
  final int meeting_id;
  final String status;
  final int id;
  MeetUpRequestModel({
    required this.user,
    required this.meeting_id,
    required this.status,
    required this.id,
  });

  MeetUpRequestModel copyWith({
    UserModel? user,
    int? meeting_id,
    String? status,
    int? id,
  }) {
    return MeetUpRequestModel(
      user: user ?? this.user,
      meeting_id: meeting_id ?? this.meeting_id,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'meeting_id': meeting_id,
      'status': status,
      'id': id,
    };
  }

  factory MeetUpRequestModel.fromMap(Map<String, dynamic> map) {
    return MeetUpRequestModel(
      user: UserModel.fromMap(map['user']),
      meeting_id: map['meeting_id']?.toInt() ?? 0,
      status: map['status'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpRequestModel.fromJson(String source) =>
      MeetUpRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpRequestModel(user: $user, meeting_id: $meeting_id, status: $status, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpRequestModel &&
        other.user == user &&
        other.meeting_id == meeting_id &&
        other.status == status &&
        other.id == id;
  }

  @override
  int get hashCode {
    return user.hashCode ^ meeting_id.hashCode ^ status.hashCode ^ id.hashCode;
  }
}
