import 'dart:convert';

class CreateMeetUpModel {
  final bool isWritten;
  final int pageIndex;
  CreateMeetUpModel({
    required this.isWritten,
    required this.pageIndex,
  });

  CreateMeetUpModel copyWith({
    bool? isWritten,
    int? pageIndex,
  }) {
    return CreateMeetUpModel(
      isWritten: isWritten ?? this.isWritten,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isWritten': isWritten,
      'pageIndex': pageIndex,
    };
  }

  factory CreateMeetUpModel.fromMap(Map<String, dynamic> map) {
    return CreateMeetUpModel(
      isWritten: map['isWritten'] ?? false,
      pageIndex: map['pageIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMeetUpModel.fromJson(String source) =>
      CreateMeetUpModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CreateMeetUpModel(isWritten: $isWritten, pageIndex: $pageIndex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateMeetUpModel &&
        other.isWritten == isWritten &&
        other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => isWritten.hashCode ^ pageIndex.hashCode;
}
