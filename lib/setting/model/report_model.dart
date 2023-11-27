// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/setting/model/user_system_model.dart';

class ReportModel {
  final int id;
  final String created_time;
  final UserSystemUserModel reporter;
  final String status;
  ReportModel({
    required this.id,
    required this.created_time,
    required this.reporter,
    required this.status,
  });

  ReportModel copyWith({
    int? id,
    String? created_time,
    UserSystemUserModel? reporter,
    String? status,
  }) {
    return ReportModel(
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
      reporter: reporter ?? this.reporter,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_time': created_time,
      'reporter': reporter.toMap(),
      'status': status,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
      reporter: UserSystemUserModel.fromMap(map['reporter']),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReportModel(id: $id, created_time: $created_time, reporter: $reporter, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportModel &&
        other.id == id &&
        other.created_time == created_time &&
        other.reporter == reporter &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        created_time.hashCode ^
        reporter.hashCode ^
        status.hashCode;
  }
}
