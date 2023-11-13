// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/meet/model/meet_up_creator_model.dart';

class ResReviewModel {
  final String context;
  final String image_url;
  final int id;
  final int meeting_id;
  final MeetUpCreatorModel creator;
  ResReviewModel({
    required this.context,
    required this.image_url,
    required this.id,
    required this.meeting_id,
    required this.creator,
  });

  ResReviewModel copyWith({
    String? context,
    String? image_url,
    int? id,
    int? meeting_id,
    MeetUpCreatorModel? creator,
  }) {
    return ResReviewModel(
      context: context ?? this.context,
      image_url: image_url ?? this.image_url,
      id: id ?? this.id,
      meeting_id: meeting_id ?? this.meeting_id,
      creator: creator ?? this.creator,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'context': context,
      'image_url': image_url,
      'id': id,
      'meeting_id': meeting_id,
      'creator': creator.toMap(),
    };
  }

  factory ResReviewModel.fromMap(Map<String, dynamic> map) {
    return ResReviewModel(
      context: map['context'] ?? '',
      image_url: map['image_url'] ?? '',
      id: map['id']?.toInt() ?? 0,
      meeting_id: map['meeting_id']?.toInt() ?? 0,
      creator: MeetUpCreatorModel.fromMap(map['creator']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResReviewModel.fromJson(String source) =>
      ResReviewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResReviewModel(context: $context, image_url: $image_url, id: $id, meeting_id: $meeting_id, creator: $creator)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResReviewModel &&
        other.context == context &&
        other.image_url == image_url &&
        other.id == id &&
        other.meeting_id == meeting_id &&
        other.creator == creator;
  }

  @override
  int get hashCode {
    return context.hashCode ^
        image_url.hashCode ^
        id.hashCode ^
        meeting_id.hashCode ^
        creator.hashCode;
  }
}
