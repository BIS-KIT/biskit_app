// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class LoginResponse {
  final String access_token;
  final String refresh_token;
  final String token_type;
  LoginResponse({
    required this.access_token,
    required this.refresh_token,
    required this.token_type,
  });

  LoginResponse copyWith({
    String? access_token,
    String? refresh_token,
    String? token_type,
  }) {
    return LoginResponse(
      access_token: access_token ?? this.access_token,
      refresh_token: refresh_token ?? this.refresh_token,
      token_type: token_type ?? this.token_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': access_token,
      'refresh_token': refresh_token,
      'token_type': token_type,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      access_token: map['access_token'] as String,
      refresh_token: map['refresh_token'] as String,
      token_type: map['token_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoginResponse(access_token: $access_token, refresh_token: $refresh_token, token_type: $token_type)';

  @override
  bool operator ==(covariant LoginResponse other) {
    if (identical(this, other)) return true;

    return other.access_token == access_token &&
        other.refresh_token == refresh_token &&
        other.token_type == token_type;
  }

  @override
  int get hashCode =>
      access_token.hashCode ^ refresh_token.hashCode ^ token_type.hashCode;
}
