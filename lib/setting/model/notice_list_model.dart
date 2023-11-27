// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/setting/model/notice_model.dart';

class NoticeListModel {
  final List<NoticeModel> notices;
  final int total_count;
  NoticeListModel({
    required this.notices,
    required this.total_count,
  });

  NoticeListModel copyWith({
    List<NoticeModel>? notices,
    int? total_count,
  }) {
    return NoticeListModel(
      notices: notices ?? this.notices,
      total_count: total_count ?? this.total_count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notices': notices.map((x) => x.toMap()).toList(),
      'total_count': total_count,
    };
  }

  factory NoticeListModel.fromMap(Map<String, dynamic> map) {
    return NoticeListModel(
      notices: List<NoticeModel>.from(
          map['notices']?.map((x) => NoticeModel.fromMap(x))),
      total_count: map['total_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeListModel.fromJson(String source) =>
      NoticeListModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NoticeListModel(notices: $notices, total_count: $total_count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoticeListModel &&
        listEquals(other.notices, notices) &&
        other.total_count == total_count;
  }

  @override
  int get hashCode => notices.hashCode ^ total_count.hashCode;
}
