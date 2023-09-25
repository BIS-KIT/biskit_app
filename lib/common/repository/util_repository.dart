import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final utilRepositoryProvider = Provider<UtilRepository>(
  (ref) => UtilRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
  ),
);

class UtilRepository {
  final Dio dio;
  final String baseUrl;
  UtilRepository({
    required this.dio,
    required this.baseUrl,
  });

  getLanguages() async {
    final res = await dio.get(
      '$baseUrl/languages',
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

  Future<List<NationalFlagModel>> getNationality(
      {required String osLanguage, required String search}) async {
    List<NationalFlagModel> list = [];
    final res = await dio.get(
      '$baseUrl/nationality',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      queryParameters: {
        'os_language': osLanguage == kEn ? 'english' : 'korean',
        'search': search,
      },
    );
    logger.d(res.toString());
    if (res.data != null) {
      list = List<NationalFlagModel>.from(
          res.data.map((e) => NationalFlagModel.fromMap(e)).toList());
    }
    return list;
  }
}
