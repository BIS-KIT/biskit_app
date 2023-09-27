// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class IntroductionModel {
  final int id;
  final String keyword;
  final String context;
  final int profile_id;
  IntroductionModel({
    required this.id,
    required this.keyword,
    required this.context,
    required this.profile_id,
  });

  IntroductionModel copyWith({
    int? id,
    String? keyword,
    String? context,
    int? profile_id,
  }) {
    return IntroductionModel(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      context: context ?? this.context,
      profile_id: profile_id ?? this.profile_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'keyword': keyword,
      'context': context,
      'profile_id': profile_id,
    };
  }

  factory IntroductionModel.fromMap(Map<String, dynamic> map) {
    return IntroductionModel(
      id: map['id'] as int,
      keyword: map['keyword'] as String,
      context: map['context'] as String,
      profile_id: map['profile_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory IntroductionModel.fromJson(String source) =>
      IntroductionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IntroductionModel(id: $id, keyword: $keyword, context: $context, profile_id: $profile_id)';
  }

  @override
  bool operator ==(covariant IntroductionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.keyword == keyword &&
        other.context == context &&
        other.profile_id == profile_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        keyword.hashCode ^
        context.hashCode ^
        profile_id.hashCode;
  }
}
