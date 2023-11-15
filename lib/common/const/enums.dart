// ignore_for_file: camel_case_types, constant_identifier_names

enum VerificationStatus {
  PENDING,
  VERIFIED,
  REJECTED,
  UNVERIFIED,
}

/// 로그인 sns 타입
enum SnsType {
  kakao,
  google,
  apple,
}

/// Upload image source
enum UploadImageType {
  PROFILE,
  STUDENT_CARD,
  REVIEW,
  CHATTING,
}
