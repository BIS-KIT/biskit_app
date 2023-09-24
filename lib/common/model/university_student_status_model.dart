class UniversityStudentStatusModel {
  final String ename;
  final String kname;
  final bool isCheck;
  UniversityStudentStatusModel({
    required this.ename,
    required this.kname,
    this.isCheck = false,
  });

  UniversityStudentStatusModel copyWith({
    String? ename,
    String? kname,
    bool? isCheck,
  }) {
    return UniversityStudentStatusModel(
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
