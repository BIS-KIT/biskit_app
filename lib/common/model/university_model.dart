import 'dart:convert';

class UniversityModel {
  final String code;
  final String ename;
  final String kname;
  UniversityModel({
    required this.code,
    required this.ename,
    required this.kname,
  });

  UniversityModel copyWith({
    String? code,
    String? ename,
    String? kname,
  }) {
    return UniversityModel(
      code: code ?? this.code,
      ename: ename ?? this.ename,
      kname: kname ?? this.kname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'ename': ename,
      'kname': kname,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      code: map['code'] ?? '',
      ename: map['ename'] ?? '',
      kname: map['kname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityModel.fromJson(String source) =>
      UniversityModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UniversityModel(code: $code, ename: $ename, kname: $kname)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversityModel &&
        other.code == code &&
        other.ename == ename &&
        other.kname == kname;
  }

  @override
  int get hashCode => code.hashCode ^ ename.hashCode ^ kname.hashCode;
}
