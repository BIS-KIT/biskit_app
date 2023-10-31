import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/profile/model/language_model.dart';
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

  Future<List<LanguageModel>> getLanguages() async {
    List<LanguageModel> list = [];
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
    list = List.from((res.data as List).map((e) => LanguageModel.fromMap(e)));

    return list;
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

  getUniversty({
    required String languageCode,
    required String search,
  }) async {
    List<NationalFlagModel> list = [];
    final res = await dio.get(
      '$baseUrl/universty',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      queryParameters: {
        'os_language': languageCode == kEn ? 'english' : 'korean',
        'search': search,
      },
    );
    logger.d(res.toString());
    if (res.data != null) {
      // list = List<NationalFlagModel>.from(
      //     res.data.map((e) => NationalFlagModel.fromMap(e)).toList());
    }
    return list;
  }

  Future<List<TopicModel>> getTopics() async {
    List<TopicModel> list = [];
    final res = await dio.get(
      '$baseUrl/topics',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    logger.d(res.toString());
    list = List.from((res.data as List).map((e) => TopicModel.fromMap(e)));

    return list;
  }

  getTags() async {
    List<TagModel> list = [];
    final res = await dio.get(
      '$baseUrl/tags',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    logger.d(res.toString());
    list = List.from((res.data as List).map((e) => TagModel.fromMap(e)));

    return list;
  }
}
