// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/alarm/model/alarm_model.dart';
import 'package:flutter/foundation.dart';

abstract class AlarmListModelBase {}

class AlarmListModelError extends AlarmListModelBase {
  final String message;
  AlarmListModelError({
    required this.message,
  });
}

class AlarmListModelLoading extends AlarmListModelBase {}

class AlarmListModel extends AlarmListModelBase {
  final int total_count;
  final List<AlarmModel> alarms;
  AlarmListModel({
    required this.total_count,
    required this.alarms,
  });

  AlarmListModel copyWith({
    int? total_count,
    List<AlarmModel>? alarms,
  }) {
    return AlarmListModel(
      total_count: total_count ?? this.total_count,
      alarms: alarms ?? this.alarms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_count': total_count,
      'alarms': alarms.map((x) => x.toMap()).toList(),
    };
  }

  factory AlarmListModel.fromMap(Map<String, dynamic> map) {
    return AlarmListModel(
      total_count: map['total_count']?.toInt() ?? 0,
      alarms: List<AlarmModel>.from(
          map['alarms']?.map((x) => AlarmModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AlarmListModel.fromJson(String source) =>
      AlarmListModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AlarmListModel(total_count: $total_count, alarms: $alarms)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlarmListModel &&
        other.total_count == total_count &&
        listEquals(other.alarms, alarms);
  }

  @override
  int get hashCode => total_count.hashCode ^ alarms.hashCode;
}
