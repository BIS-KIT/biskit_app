class UniversityGraduateStatusModel {
  final String ename;
  final String kname;
  final bool isCheck;
  UniversityGraduateStatusModel({
    required this.ename,
    required this.kname,
    this.isCheck = false,
  });

  UniversityGraduateStatusModel copyWith({
    String? ename,
    String? kname,
    bool? isCheck,
  }) {
    return UniversityGraduateStatusModel(
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
