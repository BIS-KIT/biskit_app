// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class IntroductionCreateModel {
  final String keyword;
  final String context;
  IntroductionCreateModel({
    required this.keyword,
    required this.context,
  });

  IntroductionCreateModel copyWith({
    String? keyword,
    String? context,
  }) {
    return IntroductionCreateModel(
      keyword: keyword ?? this.keyword,
      context: context ?? this.context,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'keyword': keyword,
      'context': context,
    };
  }

  factory IntroductionCreateModel.fromMap(Map<String, dynamic> map) {
    return IntroductionCreateModel(
      keyword: map['keyword'] as String,
      context: map['context'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IntroductionCreateModel.fromJson(String source) =>
      IntroductionCreateModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IntroductionCreateModel(keyword: $keyword, context: $context)';

  @override
  bool operator ==(covariant IntroductionCreateModel other) {
    if (identical(this, other)) return true;

    return other.keyword == keyword && other.context == context;
  }

  @override
  int get hashCode => keyword.hashCode ^ context.hashCode;
}
