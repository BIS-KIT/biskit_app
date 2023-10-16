// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ProfilePhotoModel {
  final int user_id;
  final String? profile_photo;
  final String nick_name;
  ProfilePhotoModel({
    required this.user_id,
    this.profile_photo,
    required this.nick_name,
  });

  ProfilePhotoModel copyWith({
    int? user_id,
    String? profile_photo,
    String? nick_name,
  }) {
    return ProfilePhotoModel(
      user_id: user_id ?? this.user_id,
      profile_photo: profile_photo ?? this.profile_photo,
      nick_name: nick_name ?? this.nick_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'profile_photo': profile_photo,
      'nick_name': nick_name,
    };
  }

  factory ProfilePhotoModel.fromMap(Map<String, dynamic> map) {
    return ProfilePhotoModel(
      user_id: map['user_id']?.toInt() ?? 0,
      profile_photo: map['profile_photo'],
      nick_name: map['nick_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilePhotoModel.fromJson(String source) =>
      ProfilePhotoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProfilePhotoModel(user_id: $user_id, profile_photo: $profile_photo, nick_name: $nick_name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilePhotoModel &&
        other.user_id == user_id &&
        other.profile_photo == profile_photo &&
        other.nick_name == nick_name;
  }

  @override
  int get hashCode =>
      user_id.hashCode ^ profile_photo.hashCode ^ nick_name.hashCode;
}
