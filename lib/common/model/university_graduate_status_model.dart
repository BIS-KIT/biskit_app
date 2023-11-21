import 'dart:convert';

class UniversityGraduateStatusModel {
  final String ename;
  final String kname;
  UniversityGraduateStatusModel({
    required this.ename,
    required this.kname,
  });

  UniversityGraduateStatusModel copyWith({
    String? ename,
    String? kname,
  }) {
    return UniversityGraduateStatusModel(
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

  factory UniversityGraduateStatusModel.fromMap(Map<String, dynamic> map) {
    return UniversityGraduateStatusModel(
      ename: map['ename'] ?? '',
      kname: map['kname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityGraduateStatusModel.fromJson(String source) =>
      UniversityGraduateStatusModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniversityGraduateStatusModel(ename: $ename, kname: $kname)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityGraduateStatusModel &&
        other.ename == ename &&
        other.kname == kname;
  }

  @override
  int get hashCode => ename.hashCode ^ kname.hashCode;
}
