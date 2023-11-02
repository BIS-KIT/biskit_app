// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination<T> copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }
}

class CursorPaginationMeta {
  final int count;
  final int totalCount;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.totalCount,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
    int? totalCount,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'totalCount': totalCount,
      'hasMore': hasMore,
    };
  }

  factory CursorPaginationMeta.fromMap(Map<String, dynamic> map) {
    return CursorPaginationMeta(
      count: map['count'] as int,
      totalCount: map['totalCount'] as int,
      hasMore: map['hasMore'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CursorPaginationMeta.fromJson(String source) =>
      CursorPaginationMeta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CursorPaginationMeta(count: $count, hasMore: $hasMore)';

  @override
  bool operator ==(covariant CursorPaginationMeta other) {
    if (identical(this, other)) return true;

    return other.count == count && other.hasMore == hasMore;
  }

  @override
  int get hashCode => count.hashCode ^ hasMore.hashCode;
}

// 새로고침 할때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
