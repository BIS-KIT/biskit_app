// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final settingRepositoryProvider = Provider<SettingRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SettingRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
    storage: storage,
  );
});

class SettingRepository {
  final Dio dio;
  final String baseUrl;
  final FlutterSecureStorage storage;

  SettingRepository({
    required this.dio,
    required this.baseUrl,
    required this.storage,
  });

  Future<bool> confirmPassword({
    required int userId,
    required String password,
  }) async {
    bool isConfirmed = false;
    try {
      final res = await dio.post(
        '$baseUrl/confirm-password',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'user_id': userId,
          'password': password,
        }),
      );
      if (res.statusCode == 200) {
        isConfirmed = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }

    return isConfirmed;
  }

  Future<bool> deleteUserAccount({
    required int userId,
  }) async {
    bool isDeleted = false;
    try {
      final res = await dio.delete(
        '$baseUrl/user/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );
      logger.d('deleteUserRes: $res, statusCode: ${res.statusCode}');
      if (res.statusCode == 200) {
        isDeleted = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }
    return isDeleted;
  }

  Future<bool> requestDeleteUserAccountReason({
    required String reason,
  }) async {
    bool isRequested = false;
    try {
      final res = await dio.post(
        '$baseUrl/deletion-requests',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'reason': reason,
        }),
      );
      if (res.statusCode == 200) {
        isRequested = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }
    return isRequested;
  }

  Future<UserSystemModel?> getUserSystem({required int userId}) async {
    final res = await dio.get(
      '$baseUrl/system/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
    );
    return UserSystemModel.fromMap(res.data);
  }

  Future<UserSystemModel> updateUserOSLanguage(
      {required int systemId, required String systemLang}) async {
    final res = await dio.put('$baseUrl/system/$systemId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'system_language': systemLang,
        }));
    return UserSystemModel.fromMap(res.data);
  }

  Future<UserSystemModel> updateUserAlarm(
      {required int systemId,
      required bool mainAlarm,
      required bool etcAlarm}) async {
    final res = await dio.put('$baseUrl/system/$systemId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'main_alarm': mainAlarm,
          'etc_alarm': etcAlarm,
        }));
    return UserSystemModel.fromMap(res.data);
  }
}
