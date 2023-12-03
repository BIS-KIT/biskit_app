// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:biskit_app/setting/model/blocked_user_list_model.dart';
import 'package:biskit_app/setting/model/notice_list_model.dart';
import 'package:biskit_app/setting/model/report_res_model.dart';
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
    UserSystemModel? userSystemModel;
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
    if (res.statusCode == 200) {
      userSystemModel = UserSystemModel.fromMap(res.data);
    }

    return userSystemModel;
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

  Future<BlockedUserListModel> getBlockedUserList(
      {required int userId, int? skip = 0, int? limit = 10}) async {
    final res = await dio.get('$baseUrl/ban/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'skip': skip,
          'limit': limit,
        });
    logger.d(res.data);
    return BlockedUserListModel.fromMap(res.data);
  }

  // target_id 차단하려는 id
  // reporter_id 자기자신
  Future<bool> blockUser({
    required int target_id,
    required int reporter_id,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.post(
        '$baseUrl/ban',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: {
          'target_id': target_id,
          'reporter_id': reporter_id,
        },
      );
      logger.d(res);
      if (res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e);
    }

    return isOk;
  }

  Future<bool> unblockBanIds({required List<int> ban_ids}) async {
    bool isOk = false;
    try {
      final res = await dio.delete('$baseUrl/ban',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
            },
          ),
          data: ban_ids);
      logger.d(res);
      if (res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e);
    }
    return isOk;
  }

  Future<List<ReportResModel>> getReportHistory({required int user_id}) async {
    final res = await dio.get(
      '$baseUrl/user/$user_id/report',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
    );
    logger.d(res.data);
    final List<Map<String, dynamic>> dataList =
        List<Map<String, dynamic>>.from(res.data);

    final List<ReportResModel> reportList =
        dataList.map((map) => ReportResModel.fromMap(map)).toList();
    return reportList;
  }

  Future<NoticeListModel> getNoticeList(
      {int? skip = 0, int? limit = 10}) async {
    final res = await dio.get('$baseUrl/notices',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'skip': skip,
          'limit': limit,
        });
    logger.d(res.data);
    return NoticeListModel.fromMap(res.data);
  }

  Future<void> createNotice({
    required String title,
    required String content,
    required int user_id,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/notice',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'title': title,
          'content': content,
          'user_id': user_id,
        }),
      );
      logger.d(res);
    } on DioException catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> deleteNotice({
    required int notice_id,
    required int user_id,
  }) async {
    try {
      final res = await dio.delete('$baseUrl/notice/$notice_id',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
            },
          ),
          queryParameters: {
            'user_id': user_id,
          });
      logger.d(res);
    } on DioException catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> updateNotice({
    required int notice_id,
    required int user_id,
    required String title,
    required String content,
  }) async {
    try {
      final res = await dio.put(
        '$baseUrl/notice/$notice_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'user_id': user_id,
        },
        data: json.encode({
          'title': title,
          'content': content,
        }),
      );
      logger.d(res);
    } on DioException catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> createContact({
    required String content,
    required int user_id,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/contact',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: json.encode({
          'content': content,
          'user_id': user_id,
        }),
      );
      logger.d(res.data);
    } on DioException catch (e) {
      logger.e(e.toString());
    }
  }

  postCreateReport({
    required String reason,
    required String content_type,
    required int content_id,
    required int reporter_id,
  }) async {
    ReportResModel? reportResModel;
    try {
      final res = await dio.post(
        '$baseUrl/report',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: {
          'reason': reason,
          'content_type': content_type,
          'content_id': content_id,
          'reporter_id': reporter_id,
        },
      );
      logger.d(res.data);
      if (res.statusCode == 200) {
        reportResModel = ReportResModel.fromMap(res.data);
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }
    return reportResModel;
  }

  getCheckUserBan({
    required int user_id,
    required int target_id,
  }) async {
    bool? isBan;
    try {
      final res = await dio.get(
        '$baseUrl/ban/$user_id/$target_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );
      logger.d(res);
      if (res.statusCode == 200) {
        isBan = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null && e.response!.statusCode == 404) {
        isBan = false;
      }
    }
    return isBan;
  }

  unblockUser({
    required int target_id,
    required int reporter_id,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.get(
        '$baseUrl/ban/$target_id/$target_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );
      logger.d(res);
      if (res.statusCode == 200) {
        isOk = true;
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }
}
