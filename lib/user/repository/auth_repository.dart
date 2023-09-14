import 'dart:convert';

import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/login_response.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
  );
});

class AuthRepository {
  final Ref ref;
  final Dio dio;
  AuthRepository({
    required this.ref,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await dio.post(
      'http://13.209.68.201:8000/v1/login',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: json.encode({
        'email': email,
        'password': password,
      }),
    );

    logger.d(res);
    return LoginResponse.fromMap(res.data);
  }
}
