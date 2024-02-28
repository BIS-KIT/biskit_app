import 'dart:io';

import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/profile/model/language_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

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
          'accessToken': 'true',
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
          'accessToken': 'true',
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
    List<UniversityModel> list = [];
    final res = await dio.get(
      '$baseUrl/universty',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
      queryParameters: {
        'os_language': languageCode == kEn ? 'english' : 'korean',
        'search': search,
        'skip': 0,
        'limit': 999,
      },
    );
    logger.d(res.toString());
    if (res.data != null) {
      list = List<UniversityModel>.from(
          res.data.map((e) => UniversityModel.fromMap(e)).toList());
    }
    return list;
  }

  /// read Topics
  /// None : All, true : 사용자가 생성한 것
  Future<List<TopicModel>> getTopics({bool? isCustom}) async {
    List<TopicModel> list = [];
    final res = await dio.get(
      '$baseUrl/topics',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
      queryParameters: isCustom == null
          ? null
          : {
              'is_custom': isCustom,
            },
    );

    logger.d(res.toString());
    list = List.from((res.data as List).map((e) => TopicModel.fromMap(e)));

    return list;
  }

  getTags({bool? isCustom, bool? isHome = false}) async {
    List<TagModel> list = [];
    final res = await dio.get(
      '$baseUrl/tags',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
      queryParameters: isCustom == null
          ? null
          : {
              'is_custom': isCustom,
              'is_home': isHome,
            },
    );

    logger.d(res.toString());
    list = List.from((res.data as List).map((e) => TagModel.fromMap(e)));

    return list;
  }

  uploadImage({
    required PhotoModel photo,
    required UploadImageType uploadImageType,
  }) async {
    String? path;
    File? file;
    String? filePath;

    if (photo.photoType == PhotoType.asset) {
      file = await photo.assetEntity!.originFile;
    } else {
      file = File(photo.cameraXfile!.path);
    }

    // 파일 확장자 heic 체크
    if (file != null) {
      List<String> parts = file.path.split('.');
      String extension = parts.last.toLowerCase();
      if (extension.contains('heic') || extension.contains('heif')) {
        // String? jpegPath = await HeicToJpg.convert(file.path);
        final tmpDir = (await getTemporaryDirectory()).path;
        final target = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';
        XFile? jpegXfile = await FlutterImageCompress.compressAndGetFile(
          file.path,
          target,
          format: CompressFormat.jpeg,
          quality: 90,
        );
        if (jpegXfile != null) {
          filePath = jpegXfile.path;
        }
      } else {
        filePath = file.path;
      }
      logger.d('filePath: $filePath');
    }

    Response? res;

    try {
      // create
      res = await dio.post(
        '$baseUrl/upload/image',
        options: Options(
          headers: {
            'Content-Type':
                file == null ? 'application/json' : 'multipart/form-data',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'image_source': uploadImageType.name,
        },
        data: filePath == null
            ? null
            : FormData.fromMap({
                'photo': [
                  await MultipartFile.fromFile(
                    filePath,
                    filename: filePath.split('/').last,
                  ),
                ],
              }),
      );

      if (res.statusCode == 200) {
        logger.d(res);
        path = res.data['image_url'];
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return path;
  }
}
