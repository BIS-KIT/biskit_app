import 'dart:convert';

class UniversityStudentStatusModel {
  final String ename;
  final String kname;
  UniversityStudentStatusModel({
    required this.ename,
    required this.kname,
  });

  UniversityStudentStatusModel copyWith({
    String? ename,
    String? kname,
  }) {
    return UniversityStudentStatusModel(
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ename': ename,
      'kname': kname,
    };
  }

  factory UniversityStudentStatusModel.fromMap(Map<String, dynamic> map) {
    return UniversityStudentStatusModel(
      ename: map['ename'] ?? '',
      kname: map['kname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityStudentStatusModel.fromJson(String source) =>
      UniversityStudentStatusModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniversityStudentStatusModel(ename: $ename, kname: $kname)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityStudentStatusModel &&
        other.ename == ename &&
        other.kname == kname;
  }

  @override
  int get hashCode => ename.hashCode ^ kname.hashCode;
}
