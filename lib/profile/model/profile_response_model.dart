// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class ProfileResponseModel {
  final int id;
  final int user_id;
  final String nick_name;
  final String? profile_photo;
  ProfileResponseModel({
    required this.id,
    required this.user_id,
    required this.nick_name,
    required this.profile_photo,
  });

  ProfileResponseModel copyWith({
    int? id,
    int? user_id,
    String? nick_name,
    String? profile_photo,
  }) {
    return ProfileResponseModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      nick_name: nick_name ?? this.nick_name,
      profile_photo: profile_photo ?? this.profile_photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'nick_name': nick_name,
      'profile_photo': profile_photo,
    };
  }

  factory ProfileResponseModel.fromMap(Map<String, dynamic> map) {
    return ProfileResponseModel(
      id: map['id'] as int,
      user_id: map['user_id'] as int,
      nick_name: map['nick_name'] as String,
      profile_photo:
          map['profile_photo'] != null ? map['profile_photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileResponseModel.fromJson(String source) =>
      ProfileResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileResponseModel(id: $id, user_id: $user_id, nick_name: $nick_name, profile_photo: $profile_photo)';
  }

  @override
  bool operator ==(covariant ProfileResponseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.nick_name == nick_name &&
        other.profile_photo == profile_photo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        nick_name.hashCode ^
        profile_photo.hashCode;
  }
}
