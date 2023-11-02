// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/common/model/model_with_id.dart';
import 'package:flutter/foundation.dart';

import 'package:biskit_app/meet/model/meet_up_creator_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';

class MeetUpModel implements IModelWithId {
  final int current_participants;
  final int korean_count;
  final int foreign_count;
  final String name;
  final String location;
  final String? description;
  final String meeting_time;
  final int max_participants;
  final String? image_url;
  final bool is_active;
  @override
  final int id;
  final String created_time;
  final MeetUpCreatorModel creator;
  final String participants_status;
  final List<TagModel> tags;
  MeetUpModel({
    required this.current_participants,
    required this.korean_count,
    required this.foreign_count,
    required this.name,
    required this.location,
    this.description,
    required this.meeting_time,
    required this.max_participants,
    this.image_url,
    required this.is_active,
    required this.id,
    required this.created_time,
    required this.creator,
    required this.participants_status,
    required this.tags,
  });

  MeetUpModel copyWith({
    int? current_participants,
    int? korean_count,
    int? foreign_count,
    String? name,
    String? location,
    String? description,
    String? meeting_time,
    int? max_participants,
    String? image_url,
    bool? is_active,
    int? id,
    String? created_time,
    MeetUpCreatorModel? creator,
    String? participants_status,
    List<TagModel>? tags,
  }) {
    return MeetUpModel(
      current_participants: current_participants ?? this.current_participants,
      korean_count: korean_count ?? this.korean_count,
      foreign_count: foreign_count ?? this.foreign_count,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      meeting_time: meeting_time ?? this.meeting_time,
      max_participants: max_participants ?? this.max_participants,
      image_url: image_url ?? this.image_url,
      is_active: is_active ?? this.is_active,
      id: id ?? this.id,
      created_time: created_time ?? this.created_time,
      creator: creator ?? this.creator,
      participants_status: participants_status ?? this.participants_status,
      tags: tags ?? this.tags,
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
      'image_url': image_url,
      'is_active': is_active,
      'id': id,
      'created_time': created_time,
      'creator': creator.toMap(),
      'participants_status': participants_status,
      'tags': tags.map((x) => x.toMap()).toList(),
    };
  }

  factory MeetUpModel.fromMap(Map<String, dynamic> map) {
    return MeetUpModel(
      current_participants: map['current_participants']?.toInt() ?? 0,
      korean_count: map['korean_count']?.toInt() ?? 0,
      foreign_count: map['foreign_count']?.toInt() ?? 0,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      description: map['description'],
      meeting_time: map['meeting_time'] ?? '',
      max_participants: map['max_participants']?.toInt() ?? 0,
      image_url: map['image_url'],
      is_active: map['is_active'] ?? false,
      id: map['id']?.toInt() ?? 0,
      created_time: map['created_time'] ?? '',
      creator: MeetUpCreatorModel.fromMap(map['creator']),
      participants_status: map['participants_status'] ?? '',
      tags: List<TagModel>.from(map['tags']?.map((x) => TagModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpModel.fromJson(String source) =>
      MeetUpModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetUpModel(current_participants: $current_participants, korean_count: $korean_count, foreign_count: $foreign_count, name: $name, location: $location, description: $description, meeting_time: $meeting_time, max_participants: $max_participants, image_url: $image_url, is_active: $is_active, id: $id, created_time: $created_time, creator: $creator, participants_status: $participants_status, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpModel &&
        other.current_participants == current_participants &&
        other.korean_count == korean_count &&
        other.foreign_count == foreign_count &&
        other.name == name &&
        other.location == location &&
        other.description == description &&
        other.meeting_time == meeting_time &&
        other.max_participants == max_participants &&
        other.image_url == image_url &&
        other.is_active == is_active &&
        other.id == id &&
        other.created_time == created_time &&
        other.creator == creator &&
        other.participants_status == participants_status &&
        listEquals(other.tags, tags);
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
        image_url.hashCode ^
        is_active.hashCode ^
        id.hashCode ^
        created_time.hashCode ^
        creator.hashCode ^
        participants_status.hashCode ^
        tags.hashCode;
  }
}
