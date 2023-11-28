import 'dart:convert';

import 'package:biskit_app/setting/model/user_system_model.dart';

class BlockedUserModel {
  final int id;
  final UserSystemUserModel target;
  BlockedUserModel({
    required this.id,
    required this.target,
  });

  BlockedUserModel copyWith({
    int? id,
    UserSystemUserModel? target,
  }) {
    return BlockedUserModel(
      id: id ?? this.id,
      target: target ?? this.target,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'target': target.toMap(),
    };
  }

  factory BlockedUserModel.fromMap(Map<String, dynamic> map) {
    return BlockedUserModel(
      id: map['id']?.toInt() ?? 0,
      target: UserSystemUserModel.fromMap(map['target']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedUserModel.fromJson(String source) =>
      BlockedUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'BlockedUserModel(id: $id, target: $target)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlockedUserModel &&
        other.id == id &&
        other.target == target;
  }

  @override
  int get hashCode => id.hashCode ^ target.hashCode;
}
