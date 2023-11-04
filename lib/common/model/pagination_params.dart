// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaginationParams {
  final String? after;
  final int? count;
  final int? skip;

  const PaginationParams({
    this.after,
    this.count,
    this.skip,
  });
  PaginationParams copyWith({
    String? after,
    int? count,
    int? skip,
  }) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
      skip: skip ?? this.skip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'after': after,
      'count': count,
      'skip': skip,
    };
  }

  factory PaginationParams.fromMap(Map<String, dynamic> map) {
    return PaginationParams(
      after: map['after'],
      count: map['count']?.toInt(),
      skip: map['skip']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationParams.fromJson(String source) =>
      PaginationParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'PaginationParams(after: $after, count: $count, skip: $skip)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationParams &&
        other.after == after &&
        other.count == count &&
        other.skip == skip;
  }

  @override
  int get hashCode => after.hashCode ^ count.hashCode ^ skip.hashCode;
}
