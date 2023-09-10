extension InputValidate on String {
  /// 이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

bool isValidPassword(String password) {
  // 영문자, 숫자, 특수문자 중 하나 이상 포함, 총 길이는 8 이상 16 이하
  final RegExp pattern = RegExp(r'^(?=.*?[a-zA-Z0-9!@#\$&*~]).{8,16}$');

  // 조건에 맞는지 검사
  return pattern.hasMatch(password);
}
