import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'ename': ename,
      'kname': kname,
      'isCheck': isCheck,
    };
  }

  factory UniversityStudentStatusModel.fromMap(Map<String, dynamic> map) {
    return UniversityStudentStatusModel(
      ename: map['ename'] ?? '',
      kname: map['kname'] ?? '',
      isCheck: map['isCheck'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityStudentStatusModel.fromJson(String source) =>
      UniversityStudentStatusModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniversityStudentStatusModel(ename: $ename, kname: $kname, isCheck: $isCheck)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityStudentStatusModel &&
        other.ename == ename &&
        other.kname == kname &&
        other.isCheck == isCheck;
  }

  @override
  int get hashCode => ename.hashCode ^ kname.hashCode ^ isCheck.hashCode;
}
