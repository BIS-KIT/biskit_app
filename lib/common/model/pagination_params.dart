// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });
  PaginationParams copyWith({
    String? after,
    int? count,
  }) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'after': after,
      'count': count,
    };
  }

  factory PaginationParams.fromMap(Map<String, dynamic> map) {
    return PaginationParams(
      after: map['after'] != null ? map['after'] as String : null,
      count: map['count'] != null ? map['count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationParams.fromJson(String source) =>
      PaginationParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PaginationParams(after: $after, count: $count)';

  @override
  bool operator ==(covariant PaginationParams other) {
    if (identical(this, other)) return true;

    return other.after == after && other.count == count;
  }

  @override
  int get hashCode => after.hashCode ^ count.hashCode;
}
