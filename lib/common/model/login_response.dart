// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class LoginResponse {
  final String access_token;
  final String token_type;
  LoginResponse({
    required this.access_token,
    required this.token_type,
  });

  LoginResponse copyWith({
    String? access_token,
    String? token_type,
  }) {
    return LoginResponse(
      access_token: access_token ?? this.access_token,
      token_type: token_type ?? this.token_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': access_token,
      'token_type': token_type,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      access_token: map['access_token'] ?? '',
      token_type: map['token_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginResponse(access_token: $access_token, token_type: $token_type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginResponse &&
        other.access_token == access_token &&
        other.token_type == token_type;
  }

  @override
  int get hashCode => access_token.hashCode ^ token_type.hashCode;
}
