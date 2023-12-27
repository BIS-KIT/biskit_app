// ignore_for_file: non_constant_identifier_names

import 'package:biskit_app/alarm/model/alarm_list_model.dart';
import 'package:biskit_app/alarm/model/alarm_model.dart';
import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AlarmRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
    storage: storage,
  );
});

class AlarmRepository {
  final Dio dio;
  final String baseUrl;
  final FlutterSecureStorage storage;

  AlarmRepository({
    required this.dio,
    required this.baseUrl,
    required this.storage,
  });

  Future<AlarmListModel?> getAlarmList({
    required int user_id,
    int? skip = 0,
    int? limit = 10,
  }) async {
    AlarmListModel? alarms;
    try {
      final res = await dio.get(
        '$baseUrl/alarms/$user_id',
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
        },
      );
      logger.d(res);
      if (res.statusCode == 200) {
        alarms = AlarmListModel.fromMap(res.data);
      }
    } on DioException catch (e) {
      logger.d(e.toString());
    }
    return alarms;
  }

  readAlarm({required int alarm_id}) async {
    AlarmModel? alarm;
    try {
      final res = await dio.put(
        '$baseUrl/alarm/$alarm_id',
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
        alarm = AlarmModel.fromJson(res.data);
      }
    } on DioException catch (e) {
      logger.e(e.toString());
    }
    return alarm;
  }
}
