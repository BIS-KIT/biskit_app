import 'dart:convert';

import 'package:biskit_app/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/login_response.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
  );
});

class AuthRepository {
  final Ref ref;
  final Dio dio;
  final String baseUrl;
  AuthRepository({
    required this.ref,
    required this.dio,
    required this.baseUrl,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await dio.post(
      '$baseUrl/login',
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
