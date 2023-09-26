import 'dart:convert';

import 'package:flutter/foundation.dart';

class ApiResModel {
  final bool isOk;
  final String? message;
  final Map<String, dynamic>? data;
  ApiResModel({
    this.isOk = false,
    this.message = '앗, 뭔가 문제가 생겼어요..',
    this.data,
  });

  ApiResModel copyWith({
    bool? isOk,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return ApiResModel(
      isOk: isOk ?? this.isOk,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOk': isOk,
      'message': message,
      'data': data,
    };
  }

  factory ApiResModel.fromMap(Map<String, dynamic> map) {
    return ApiResModel(
      isOk: map['isOk'] ?? false,
      message: map['message'],
      data: Map<String, dynamic>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResModel.fromJson(String source) =>
      ApiResModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ApiResModel(isOk: $isOk, message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiResModel &&
        other.isOk == isOk &&
        other.message == message &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode => isOk.hashCode ^ message.hashCode ^ data.hashCode;
}
