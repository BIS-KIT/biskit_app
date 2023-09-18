class UniversityModel {
  final String code;
  final String ename;
  final String kname;
  final bool isCheck;
  UniversityModel({
    required this.code,
    required this.ename,
    required this.kname,
    this.isCheck = false,
  });

  UniversityModel copyWith({
    String? code,
    String? ename,
    String? kname,
    bool? isCheck,
  }) {
    return UniversityModel(
      code: code ?? this.code,
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
