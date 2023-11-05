import 'dart:convert';

class MeetUpFilterModel {
  final String text;
  final bool isSeleted;
  final String value;
  MeetUpFilterModel({
    required this.text,
    required this.isSeleted,
    required this.value,
  });

  MeetUpFilterModel copyWith({
    String? text,
    bool? isSeleted,
    String? value,
  }) {
    return MeetUpFilterModel(
      text: text ?? this.text,
      isSeleted: isSeleted ?? this.isSeleted,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isSeleted': isSeleted,
      'value': value,
    };
  }

  factory MeetUpFilterModel.fromMap(Map<String, dynamic> map) {
    return MeetUpFilterModel(
      text: map['text'] ?? '',
      isSeleted: map['isSeleted'] ?? false,
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetUpFilterModel.fromJson(String source) =>
      MeetUpFilterModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MeetUpFilterModel(text: $text, isSeleted: $isSeleted, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeetUpFilterModel &&
        other.text == text &&
        other.isSeleted == isSeleted &&
        other.value == value;
  }

  @override
  int get hashCode => text.hashCode ^ isSeleted.hashCode ^ value.hashCode;
}
