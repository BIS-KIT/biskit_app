// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/setting/model/blocked_user_model.dart';

class BlockedUserListModel {
  final List<BlockedUserModel> ban_list;
  final int total_count;
  BlockedUserListModel({
    required this.ban_list,
    required this.total_count,
  });

  BlockedUserListModel copyWith({
    List<BlockedUserModel>? ban_list,
    int? total_count,
  }) {
    return BlockedUserListModel(
      ban_list: ban_list ?? this.ban_list,
      total_count: total_count ?? this.total_count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ban_list': ban_list.map((x) => x.toMap()).toList(),
      'total_count': total_count,
    };
  }

  factory BlockedUserListModel.fromMap(Map<String, dynamic> map) {
    return BlockedUserListModel(
      ban_list: List<BlockedUserModel>.from(
          map['ban_list']?.map((x) => BlockedUserModel.fromMap(x))),
      total_count: map['total_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedUserListModel.fromJson(String source) =>
      BlockedUserListModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BlockedUserListModel(ban_list: $ban_list, total_count: $total_count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlockedUserListModel &&
        listEquals(other.ban_list, ban_list) &&
        other.total_count == total_count;
  }

  @override
  int get hashCode => ban_list.hashCode ^ total_count.hashCode;
}
