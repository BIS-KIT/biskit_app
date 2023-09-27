import 'dart:io';

import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/user/model/user_model.dart';

import '../model/profile_response_model.dart';

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

  createProfile({
    required ProfileCreateModel profileCreateModel,
  }) async {
    ProfileResponseModel? profileResponseModel;
    Response? res;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      try {
        res = await dio.post(
          '$baseUrl/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
          queryParameters: {
            'user_id': user.id,
          },
          data: profileCreateModel.toMap(),
        );

        if (res.statusCode == 200) {
          logger.d(res);
          ref.read(userMeProvider.notifier).getMe();
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return profileResponseModel;
  }

  postProfilePhoto({
    required PhotoModel profilePhoto,
  }) async {
    String? path;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      File? file = await profilePhoto.assetEntity.originFile;

      Response? res;

      try {
        if (user.profile == null) {
          // create
          res = await dio.post(
            '$baseUrl/',
            options: Options(
              headers: {
                'Content-Type':
                    file == null ? 'application/json' : 'multipart/form-data',
                'Accept': 'application/json',
              },
            ),
            queryParameters: {
              'user_id': user.id,
            },
            data: file == null
                ? null
                : FormData.fromMap({
                    'photo': [
                      await MultipartFile.fromFile(
                        file.path,
                        filename: file.path.split('/').last,
                      ),
                    ],
                  }),
          );
        } else {
          // update
        }

        if (res != null && res.statusCode == 200) {
          logger.d(res);
          path = res.data['image_url'];
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }

    return path;
  }
}
