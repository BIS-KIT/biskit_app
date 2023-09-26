import 'dart:convert';

import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/model/api_res_model.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/login_response.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
  );
});

class AuthRepository {
  final Dio dio;
  final String baseUrl;
  AuthRepository({
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

  Future<bool> checkEmail({
    required String email,
  }) async {
    bool isExist = true;
    try {
      final res = await dio.post(
        '$baseUrl/check-email/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'email': email.trim(),
        },
      );

      logger.d(res);
      if (res.statusCode == 200) {
        isExist = false;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }

    return isExist;
  }

  Future<Map<String, String>?> certificate({
    required String email,
  }) async {
    Map<String, String>? map;
    try {
      final res = await dio.post(
        '$baseUrl/certificate/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: json.encode({
          'email': email,
        }),
      );

      logger.d(res);
      if (res.statusCode == 200) {
        map = {
          'result': res.data['result'] ?? '',
          'email': res.data['email'] ?? '',
          'certification': res.data['certification'] ?? '',
        };
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }

    return map;
  }

  signUpEmail(SignUpModel signUpModel) async {
    logger.d('signUpMemail : ${signUpModel.toJson()}');
    ApiResModel apiResModel = ApiResModel(isOk: false);
    try {
      final res = await dio.post(
        '$baseUrl/register/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: signUpModel.toJson(),
      );

      logger.d(res);
      if (res.statusCode == 200) {
        apiResModel = apiResModel.copyWith(
          isOk: true,
          data: res.data,
        );
      }
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null) {
        if (e.response!.statusCode == 409) {
          apiResModel = apiResModel.copyWith(
            isOk: false,
            message: '이미 가입된 계정이 있어요',
          );
        }
      }
    }
    return apiResModel;
  }
}
