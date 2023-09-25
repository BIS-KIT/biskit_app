// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SignUpModel {
  final String? email;
  final String? password;
  final String? name;
  final String? birth;
  final String? gender;
  final bool terms_mandatory;
  final bool terms_optional;
  final bool terms_push;
  SignUpModel({
    this.email,
    this.password,
    this.name,
    this.birth,
    this.gender,
    this.terms_mandatory = false,
    this.terms_optional = false,
    this.terms_push = false,
  });

  SignUpModel copyWith({
    String? email,
    String? password,
    String? name,
    String? birth,
    String? gender,
    bool? terms_mandatory,
    bool? terms_optional,
    bool? terms_push,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      terms_mandatory: terms_mandatory ?? this.terms_mandatory,
      terms_optional: terms_optional ?? this.terms_optional,
      terms_push: terms_push ?? this.terms_push,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'name': name,
      'birth': birth,
      'gender': gender,
      'terms_mandatory': terms_mandatory,
      'terms_optional': terms_optional,
      'terms_push': terms_push,
    };
  }

  factory SignUpModel.fromMap(Map<String, dynamic> map) {
    return SignUpModel(
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      birth: map['birth'] != null ? map['birth'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      terms_mandatory: map['terms_mandatory'] as bool,
      terms_optional: map['terms_optional'] as bool,
      terms_push: map['terms_push'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpModel.fromJson(String source) =>
      SignUpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignUpModel(email: $email, password: $password, name: $name, birth: $birth, gender: $gender, terms_mandatory: $terms_mandatory, terms_optional: $terms_optional, terms_push: $terms_push)';
  }

  @override
  bool operator ==(covariant SignUpModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.name == name &&
        other.birth == birth &&
        other.gender == gender &&
        other.terms_mandatory == terms_mandatory &&
        other.terms_optional == terms_optional &&
        other.terms_push == terms_push;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        birth.hashCode ^
        gender.hashCode ^
        terms_mandatory.hashCode ^
        terms_optional.hashCode ^
        terms_push.hashCode;
  }
}
