import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class KakaoMetaModel {
  final int total_count;
  final int pageable_count;
  final bool is_end;
  KakaoMetaModel({
    required this.total_count,
    required this.pageable_count,
    required this.is_end,
  });

  KakaoMetaModel copyWith({
    int? total_count,
    int? pageable_count,
    bool? is_end,
  }) {
    return KakaoMetaModel(
      total_count: total_count ?? this.total_count,
      pageable_count: pageable_count ?? this.pageable_count,
      is_end: is_end ?? this.is_end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_count': total_count,
      'pageable_count': pageable_count,
      'is_end': is_end,
    };
  }

  factory KakaoMetaModel.fromMap(Map<String, dynamic> map) {
    return KakaoMetaModel(
      total_count: map['total_count']?.toInt() ?? 0,
      pageable_count: map['pageable_count']?.toInt() ?? 0,
      is_end: map['is_end'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory KakaoMetaModel.fromJson(String source) =>
      KakaoMetaModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'KakaoMetaModel(total_count: $total_count, pageable_count: $pageable_count, is_end: $is_end)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KakaoMetaModel &&
        other.total_count == total_count &&
        other.pageable_count == pageable_count &&
        other.is_end == is_end;
  }

  @override
  int get hashCode =>
      total_count.hashCode ^ pageable_count.hashCode ^ is_end.hashCode;
}
