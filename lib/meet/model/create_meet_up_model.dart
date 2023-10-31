// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class CreateMeetUpModel {
  final String? name;
  final String? location;
  final String? description;
  final String? meeting_time;
  final int max_participants;
  final String? image_url;
  final bool? is_active;
  final List<String> custom_tags;
  final List<String> custom_topics;
  final int creator_id;
  final List<int> tag_ids;
  final List<int> topic_ids;
  final List<int> language_ids;
  CreateMeetUpModel({
    this.name,
    this.location,
    this.description,
    this.meeting_time,
    this.max_participants = 2,
    this.image_url,
    this.is_active,
    required this.custom_tags,
    required this.custom_topics,
    required this.creator_id,
    required this.tag_ids,
    required this.topic_ids,
    required this.language_ids,
  });

  CreateMeetUpModel copyWith({
    String? name,
    String? location,
    String? description,
    String? meeting_time,
    int? max_participants,
    String? image_url,
    bool? is_active,
    List<String>? custom_tags,
    List<String>? custom_topics,
    int? creator_id,
    List<int>? tag_ids,
    List<int>? topic_ids,
    List<int>? language_ids,
  }) {
    return CreateMeetUpModel(
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      meeting_time: meeting_time ?? this.meeting_time,
      max_participants: max_participants ?? this.max_participants,
      image_url: image_url ?? this.image_url,
      is_active: is_active ?? this.is_active,
      custom_tags: custom_tags ?? this.custom_tags,
      custom_topics: custom_topics ?? this.custom_topics,
      creator_id: creator_id ?? this.creator_id,
      tag_ids: tag_ids ?? this.tag_ids,
      topic_ids: topic_ids ?? this.topic_ids,
      language_ids: language_ids ?? this.language_ids,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'meeting_time': meeting_time,
      'max_participants': max_participants,
      'image_url': image_url,
      'is_active': is_active,
      'custom_tags': custom_tags,
      'custom_topics': custom_topics,
      'creator_id': creator_id,
      'tag_ids': tag_ids,
      'topic_ids': topic_ids,
      'language_ids': language_ids,
    };
  }

  factory CreateMeetUpModel.fromMap(Map<String, dynamic> map) {
    return CreateMeetUpModel(
      name: map['name'],
      location: map['location'],
      description: map['description'],
      meeting_time: map['meeting_time'],
      max_participants: map['max_participants']?.toInt(),
      image_url: map['image_url'],
      is_active: map['is_active'],
      custom_tags: List<String>.from(map['custom_tags']),
      custom_topics: List<String>.from(map['custom_topics']),
      creator_id: map['creator_id']?.toInt() ?? 0,
      tag_ids: List<int>.from(map['tag_ids']),
      topic_ids: List<int>.from(map['topic_ids']),
      language_ids: List<int>.from(map['language_ids']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMeetUpModel.fromJson(String source) =>
      CreateMeetUpModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateMeetUpModel(name: $name, location: $location, description: $description, meeting_time: $meeting_time, max_participants: $max_participants, image_url: $image_url, is_active: $is_active, custom_tags: $custom_tags, custom_topics: $custom_topics, creator_id: $creator_id, tag_ids: $tag_ids, topic_ids: $topic_ids, language_ids: $language_ids)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateMeetUpModel &&
        other.name == name &&
        other.location == location &&
        other.description == description &&
        other.meeting_time == meeting_time &&
        other.max_participants == max_participants &&
        other.image_url == image_url &&
        other.is_active == is_active &&
        listEquals(other.custom_tags, custom_tags) &&
        listEquals(other.custom_topics, custom_topics) &&
        other.creator_id == creator_id &&
        listEquals(other.tag_ids, tag_ids) &&
        listEquals(other.topic_ids, topic_ids) &&
        listEquals(other.language_ids, language_ids);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        location.hashCode ^
        description.hashCode ^
        meeting_time.hashCode ^
        max_participants.hashCode ^
        image_url.hashCode ^
        is_active.hashCode ^
        custom_tags.hashCode ^
        custom_topics.hashCode ^
        creator_id.hashCode ^
        tag_ids.hashCode ^
        topic_ids.hashCode ^
        language_ids.hashCode;
  }
}
