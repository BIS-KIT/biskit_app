// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class StudentCard {
  final String student_card;
  final String verification_status;
  StudentCard({
    required this.student_card,
    required this.verification_status,
  });

  StudentCard copyWith({
    String? student_card,
    String? verification_status,
  }) {
    return StudentCard(
      student_card: student_card ?? this.student_card,
      verification_status: verification_status ?? this.verification_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student_card': student_card,
      'verification_status': verification_status,
    };
  }

  factory StudentCard.fromMap(Map<String, dynamic> map) {
    return StudentCard(
      student_card: map['student_card'] as String,
      verification_status: map['verification_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentCard.fromJson(String source) =>
      StudentCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentCard(student_card: $student_card, verification_status: $verification_status)';

  @override
  bool operator ==(covariant StudentCard other) {
    if (identical(this, other)) return true;

    return other.student_card == student_card &&
        other.verification_status == verification_status;
  }

  @override
  int get hashCode => student_card.hashCode ^ verification_status.hashCode;
}
