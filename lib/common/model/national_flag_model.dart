class NationalFlagModel {
  final String code;
  final String ename;
  final String kname;
  final bool isCheck;
  NationalFlagModel({
    required this.code,
    required this.ename,
    required this.kname,
    this.isCheck = false,
  });

  NationalFlagModel copyWith({
    String? code,
    String? ename,
    String? kname,
    bool? isCheck,
  }) {
    return NationalFlagModel(
      code: code ?? this.code,
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
