import 'dart:convert';

import 'package:biskit_app/common/provider/firebase_provider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/api_res_model.dart';
import 'package:biskit_app/common/model/login_response.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
    firebaseMessaging: ref.watch(firebaseMessagingProvider),
  );
});

class AuthRepository {
  final Dio dio;
  final String baseUrl;
  final FirebaseMessaging firebaseMessaging;
  AuthRepository({
    required this.dio,
    required this.baseUrl,
    required this.firebaseMessaging,
  });

  Future<LoginResponse> login({
    String? email,
    String? password,
    String? snsType,
    String? snsId,
  }) async {
    String? fcmToken = await firebaseMessaging.getToken();
    Object data = json.encode({
      'email': email,
      'password': password,
      'sns_type': snsType,
      'sns_id': snsId,
      'fcm_token': fcmToken,
    });
    logger.d(data.toString());
    final res = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: data,
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
        '$baseUrl/check-email',
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
        '$baseUrl/certificate',
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
    signUpModel = signUpModel.copyWith(
      fcm_token: await firebaseMessaging.getToken(),
    );
    logger.d('signUpMemail : ${signUpModel.toJson()}');
    ApiResModel apiResModel = ApiResModel(isOk: false);
    try {
      final res = await dio.post(
        '$baseUrl/register',
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

  deleteUser(int userId) async {
    bool isOk = false;
    final res = await dio.delete(
      '$baseUrl/user/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    logger.d('DELETE USER: $res');
    if (res.statusCode == 200) {
      isOk = true;
    }
    return isOk;
  }

  Future<Map<String, String>?> changePasswordCertificate({
    required String email,
  }) async {
    Map<String, String>? map;
    try {
      final res = await dio.post(
        '$baseUrl/change-password/certificate',
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

  Future<Map<String, String>?> changePasswordCertificateCheck({
    required String email,
    required String pinCode,
  }) async {
    Map<String, String>? map;
    try {
      final res = await dio.post(
        '$baseUrl/change-password/certificate/check',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: json.encode({
          'email': email,
          'certification': pinCode,
        }),
      );

      logger.d(res);
      if (res.statusCode == 200) {
        map = {
          'result': res.data['result'] ?? '',
          'email': res.data['email'] ?? '',
          'token': res.data['token'] ?? '',
        };
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }

    return map;
  }

  Future<bool> changePassword({
    required String? token,
    required String newPassword,
  }) async {
    bool isChanged = false;
    try {
      final res = await dio.post(
        '$baseUrl/change-password',
        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: json.encode({
          'new_password': newPassword,
          'new_password_check': newPassword,
        }),
      );
      logger.d(res);
      if (res.statusCode == 200) {
        isChanged = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }

    return isChanged;
  }
}
