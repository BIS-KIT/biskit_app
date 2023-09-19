extension InputValidate on String {
  /// 이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  /// 비밀번호 포맷 검증 영문자, 숫자, 특수문자 중 하나 이상 포함, 총 길이는 8 이상 16 이하
  bool isValidPassword() {
    final RegExp pattern = RegExp(r'^(?=.*?[a-zA-Z0-9!@#\$&*~]).{8,16}$');

    // 조건에 맞는지 검사
    return pattern.hasMatch(this);
  }

  /// 닉네임 검증
  bool isNickName() {
    return RegExp(r'^(?=.*[a-z0-9가-힣])[a-z0-9가-힣]{2,12}$').hasMatch(this);
  }
}
