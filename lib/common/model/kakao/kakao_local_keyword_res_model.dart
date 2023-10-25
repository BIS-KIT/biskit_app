import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biskit_app/common/model/kakao/kakao_document_model.dart';
import 'package:biskit_app/common/model/kakao/kakao_meta_model.dart';

class KakaoLocalKeywordResModel {
  final KakaoMetaModel meta;
  final List<KakaoDocumentModel> documents;
  KakaoLocalKeywordResModel({
    required this.meta,
    required this.documents,
  });

  KakaoLocalKeywordResModel copyWith({
    KakaoMetaModel? meta,
    List<KakaoDocumentModel>? documents,
  }) {
    return KakaoLocalKeywordResModel(
      meta: meta ?? this.meta,
      documents: documents ?? this.documents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meta': meta.toMap(),
      'documents': documents.map((x) => x.toMap()).toList(),
    };
  }

  factory KakaoLocalKeywordResModel.fromMap(Map<String, dynamic> map) {
    return KakaoLocalKeywordResModel(
      meta: KakaoMetaModel.fromMap(map['meta']),
      documents: List<KakaoDocumentModel>.from(
          map['documents']?.map((x) => KakaoDocumentModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory KakaoLocalKeywordResModel.fromJson(String source) =>
      KakaoLocalKeywordResModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'KakaoLocalKeywordResModel(meta: $meta, documents: $documents)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KakaoLocalKeywordResModel &&
        other.meta == meta &&
        listEquals(other.documents, documents);
  }

  @override
  int get hashCode => meta.hashCode ^ documents.hashCode;
}
