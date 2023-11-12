// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/profile/model/language_model.dart';
import 'package:biskit_app/user/model/user_model.dart';

class UserNationalityModel {
  final int id;
  final NationalFlagModel nationality;
  final int user_id;
  UserNationalityModel({
    required this.id,
    required this.nationality,
    required this.user_id,
  });

  UserNationalityModel copyWith({
    int? id,
    NationalFlagModel? nationality,
    int? user_id,
  }) {
    return UserNationalityModel(
      id: id ?? this.id,
      nationality: nationality ?? this.nationality,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationality': nationality.toMap(),
      'user_id': user_id,
    };
  }

  factory UserNationalityModel.fromMap(Map<String, dynamic> map) {
    return UserNationalityModel(
      id: map['id']?.toInt() ?? 0,
      nationality: NationalFlagModel.fromMap(map['nationality']),
      user_id: map['user_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserNationalityModel.fromJson(String source) =>
      UserNationalityModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserNationalityModel(id: $id, nationality: $nationality, user_id: $user_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserNationalityModel &&
        other.id == id &&
        other.nationality == nationality &&
        other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ nationality.hashCode ^ user_id.hashCode;
}

class CreatorModel {
  final int id;
  final String email;
  final String name;
  final String birth;
  final String gender;
  final List<UserNationalityModel> user_nationality;
  CreatorModel({
    required this.id,
    required this.email,
    required this.name,
    required this.birth,
    required this.gender,
    required this.user_nationality,
  });

  CreatorModel copyWith({
    int? id,
    String? email,
    String? name,
    String? birth,
    String? gender,
    List<UserNationalityModel>? user_nationality,
  }) {
    return CreatorModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      user_nationality: user_nationality ?? this.user_nationality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birth': birth,
      'gender': gender,
      'user_nationality': user_nationality.map((x) => x.toMap()).toList(),
    };
  }

  factory CreatorModel.fromMap(Map<String, dynamic> map) {
    return CreatorModel(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
      user_nationality: List<UserNationalityModel>.from(
          map['user_nationality']?.map((x) => UserNationalityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatorModel.fromJson(String source) =>
      CreatorModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreatorModel(id: $id, email: $email, name: $name, birth: $birth, gender: $gender, user_nationality: $user_nationality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatorModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        listEquals(other.user_nationality, user_nationality);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        user_nationality.hashCode;
  }
}

class MeetUpDetailModel {
  final int current_participants;
  final int korean_count;
  final int foreign_count;
  final String name;
  final String location;
  final String description;
  final String meeting_time;
  final int max_participants;
  final String chat_id;
  final String place_url;
  final String x_coord;
  final String y_coord;
  final String image_url;
  final bool is_active;
  final int id;
  final String created_time;
  final CreatorModel creator;
  final String participants_status;
  final List<TagModel> tags;
  final List<TopicModel> topics;
  final List<LanguageModel> languages;
  final List<UserModel> participants;
  MeetUpDetailModel({
    required this.current_participants,
    required this.korean_count,
    required this.foreign_count,
    required this.name,
    required this.location,
    required this.description,
    required this.meeting_time,
    required this.max_participants,
    required this.chat_id,
    required this.place_url,
    required this.x_coord,
    required this.y_coord,
    required this.image_url,
    required this.is_active,
    required this.id,
    required this.created_time,
    required this.creator,
    required this.participants_status,
    required this.tags,
    required this.topics,
    required this.languages,
    required this.participants,
  });

  MeetUpDetailModel copyWith({
    int? current_participants,
    int? korean_count,
    int? foreign_count,
    String? name,
    String? location,
    String? description,
    String? meeting_time,
    int? max_participants,
    String? chat_id,
    String? place_url,
    String? x_coord,
    String? y_coord,
    String? image_url,
    bool? is_active,
    int? id,
    String? created_time,
    CreatorModel? creator,
    String? participants_status,
    List<TagModel>? tags,
    List<TopicModel>? topics,
    List<LanguageModel>? languages,
    List<UserModel>? participants,
  }) {
    return MeetUpDetailModel(
      current_participants: current_participants ?? this.current_participants,
      korean_count: korean_count ?? this.korean_count,
      foreign_count: foreign_count ?? this.foreign_count,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      meeting_time: meeting_time ?? this.meeting_time,
      max_participants: max_participants ?? this.max_participants,
      chat_id: chat_id ?? this.chat_id,
      place_url: place_url ?? this.place_url,
      x_coord: x_coord ?? this.x_coord,
      y_coord: y_coord ?? this.y_coord,
      image_url: image_url ?? this.image_url,
      is_active: is_active ?? this.is_active,
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
      creator: creator ?? this.creator,
      participants_status: participants_status ?? this.participants_status,
      tags: tags ?? this.tags,
      topics: topics ?? this.topics,
      languages: languages ?? this.languages,
      participants: participants ?? this.participants,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current_participants': current_participants,
      'korean_count': korean_count,
      'foreign_count': foreign_count,
      'name': name,
      'location': location,
      'description': description,
      'meeting_time': meeting_time,
      'max_participants': max_participants,
      'chat_id': chat_id,
      'place_url': place_url,
      'x_coord': x_coord,
      'y_coord': y_coord,
      'image_url': image_url,
      'is_active': is_active,
      'id': id,
      'created_time': created_time,
      'creator': creator.toMap(),
      'participants_status': participants_status,
      'tags': tags.map((x) => x.toMap()).toList(),
      'topics': topics.map((x) => x.toMap()).toList(),
      'languages': languages.map((x) => x.toMap()).toList(),
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }

  factory MeetUpDetailModel.fromMap(Map<String, dynamic> map) {
    return MeetUpDetailModel(
      current_participants: map['current_participants']?.toInt() ?? 0,
      korean_count: map['korean_count']?.toInt() ?? 0,
      foreign_count: map['foreign_count']?.toInt() ?? 0,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      meeting_time: map['meeting_time'] ?? '',
      max_participants: map['max_participants']?.toInt() ?? 0,
      chat_id: map['chat_id'] ?? '',
      place_url: map['place_url'] ?? '',
      x_coord: map['x_coord'] ?? '',
      y_coord: map['y_coord'] ?? '',
      image_url: map['image_url'] ?? '',
      is_active: map['is_active'] ?? false,
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
      creator: CreatorModel.fromMap(map['creator']),
      participants_status: map['participants_status'] ?? '',
      tags: List<TagModel>.from(map['tags']?.map((x) => TagModel.fromMap(x))),
      topics: List<TopicModel>.from(
          map['topics']?.map((x) => TopicModel.fromMap(x))),
      languages: List<LanguageModel>.from(
          map['languages']?.map((x) => LanguageModel.fromMap(x))),
      participants: List<UserModel>.from(
          map['participants']?.map((x) => UserModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpDetailModel.fromJson(String source) =>
      MeetUpDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpDetailModel(current_participants: $current_participants, korean_count: $korean_count, foreign_count: $foreign_count, name: $name, location: $location, description: $description, meeting_time: $meeting_time, max_participants: $max_participants, chat_id: $chat_id, place_url: $place_url, x_coord: $x_coord, y_coord: $y_coord, image_url: $image_url, is_active: $is_active, id: $id, created_time: $created_time, creator: $creator, participants_status: $participants_status, tags: $tags, topics: $topics, languages: $languages, participants: $participants)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpDetailModel &&
        other.current_participants == current_participants &&
        other.korean_count == korean_count &&
        other.foreign_count == foreign_count &&
        other.name == name &&
        other.location == location &&
        other.description == description &&
        other.meeting_time == meeting_time &&
        other.max_participants == max_participants &&
        other.chat_id == chat_id &&
        other.place_url == place_url &&
        other.x_coord == x_coord &&
        other.y_coord == y_coord &&
        other.image_url == image_url &&
        other.is_active == is_active &&
        other.id == id &&
        other.created_time == created_time &&
        other.creator == creator &&
        other.participants_status == participants_status &&
        listEquals(other.tags, tags) &&
        listEquals(other.topics, topics) &&
        listEquals(other.languages, languages) &&
        listEquals(other.participants, participants);
  }

  @override
  int get hashCode {
    return current_participants.hashCode ^
        korean_count.hashCode ^
        foreign_count.hashCode ^
        name.hashCode ^
        location.hashCode ^
        description.hashCode ^
        meeting_time.hashCode ^
        max_participants.hashCode ^
        chat_id.hashCode ^
        place_url.hashCode ^
        x_coord.hashCode ^
        y_coord.hashCode ^
        image_url.hashCode ^
        is_active.hashCode ^
        id.hashCode ^
        created_time.hashCode ^
        creator.hashCode ^
        participants_status.hashCode ^
        tags.hashCode ^
        topics.hashCode ^
        languages.hashCode ^
        participants.hashCode;
  }
}
