import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/profile',
  ),
);

class ProfileRepository {
  final Ref ref;
  final Dio dio;
  final String baseUrl;
  ProfileRepository({
    required this.ref,
    required this.dio,
    required this.baseUrl,
  });

  getRandomNickname() async {
    final res = await dio.get(
      '$baseUrl/random-nickname',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    logger.d(res.toString());
    return res;
  }

  Future<bool> getCheckNickName(String nickName) async {
    bool isOk = false;

    final res = await dio.get(
      '$baseUrl/nick-name',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      queryParameters: {
        'nick_name': nickName,
      },
    );

    logger.d(res.toString());
    if (res.statusCode == 200 && res.data != null) {
      isOk = (res.data['status'] ?? '') == 'Nick_name is available.';
    }

    return isOk;
  }
}
