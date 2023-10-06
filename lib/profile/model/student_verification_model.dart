// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class StudentVerificationModel {
  final int id;
  final String student_card;
  final String verification_status;
  StudentVerificationModel({
    required this.id,
    required this.student_card,
    required this.verification_status,
  });

  StudentVerificationModel copyWith({
    int? id,
    String? student_card,
    String? verification_status,
  }) {
    return StudentVerificationModel(
      id: id ?? this.id,
      student_card: student_card ?? this.student_card,
      verification_status: verification_status ?? this.verification_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'student_card': student_card,
      'verification_status': verification_status,
    };
  }

  factory StudentVerificationModel.fromMap(Map<String, dynamic> map) {
    return StudentVerificationModel(
      id: map['id'] as int,
      student_card: map['student_card'] as String,
      verification_status: map['verification_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentVerificationModel.fromJson(String source) =>
      StudentVerificationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentVerificationModel(id: $id, student_card: $student_card, verification_status: $verification_status)';

  @override
  bool operator ==(covariant StudentVerificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.student_card == student_card &&
        other.verification_status == verification_status;
  }

  @override
  int get hashCode =>
      id.hashCode ^ student_card.hashCode ^ verification_status.hashCode;
}
