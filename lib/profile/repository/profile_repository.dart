// ignore_for_file: non_constant_identifier_names

import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/model/profile_photo_model.dart';
import 'package:biskit_app/profile/model/student_verification_model.dart';
import 'package:biskit_app/profile/provider/profile_meeting_provider.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<Map<String, String>?> getRandomNickname(String? osLang) async {
    Map<String, String>? result;
    try {
      final res = await dio.get(
        '$baseUrl/random-nickname',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'os_lang': osLang ?? 'kr',
        },
      );
      if (res.statusCode == 200) {
        logger.d(res.toString());
        result = {
          'kr_nick_name': res.data['kr_nick_name'].toString(),
          'en_nick_name': res.data['en_nick_name'].toString(),
        };
      }
    } catch (e) {
      logger.e(e.toString());
    }

    return result;
  }

  Future<String?> getRandomProfile() async {
    String? imageUrl;
    final res = await dio.get(
      '$baseUrl/random-image',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
    );

    logger.d(res.toString());
    if (res.statusCode == 200) {
      imageUrl = res.data['image_url'];
    }
    return imageUrl;
  }

  Future<bool> getCheckNickName(String nickName) async {
    bool isOk = false;

    try {
      final res = await dio.get(
        '$baseUrl/nick-name',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
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
    } catch (e) {
      logger.e(e.toString());
    }

    return isOk;
  }

  getProfilePhotos(List<int> userIds) async {
    List<ProfilePhotoModel> profilePhotoModel = [];
    final res = await dio.get(
      '$baseUrl/photos',
      // '$baseUrl/photos?${userIds.map((e) => 'user_ids=$e&').join('')}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
      queryParameters: {
        'user_ids': userIds,
      },
    );

    logger.d(res.toString());
    if (res.statusCode == 200 && res.data != null) {
      profilePhotoModel = List.from(res.data
          .map((e) => ProfilePhotoModel.fromMap(e as Map<String, dynamic>)));
    }
    return profilePhotoModel;
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
          baseUrl,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
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

  // postProfilePhoto({
  //   required PhotoModel profilePhoto,
  //   required bool isProfile,
  // }) async {
  //   String? path;
  //   // final user = ref.watch(userMeProvider);
  //   // if (user is UserModel) {

  //   //   } catch (e) {
  //   //     logger.e(e.toString());
  //   //   }
  //   // }
  //   File? file;

  //   if (profilePhoto.photoType == PhotoType.asset) {
  //     file = await profilePhoto.assetEntity!.originFile;
  //   } else {
  //     file = File(profilePhoto.cameraXfile!.path);
  //   }

  //   Response? res;

  //   try {
  //     // create
  //     res = await dio.post(
  //       '$baseUrl/photo',
  //       options: Options(
  //         headers: {
  //           'Content-Type':
  //               file == null ? 'application/json' : 'multipart/form-data',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //       queryParameters: {
  //         'is_profile': isProfile,
  //       },
  //       data: file == null
  //           ? null
  //           : FormData.fromMap({
  //               'photo': [
  //                 await MultipartFile.fromFile(
  //                   file.path,
  //                   filename: file.path.split('/').last,
  //                 ),
  //               ],
  //             }),
  //     );

  //     if (res.statusCode == 200) {
  //       logger.d(res);
  //       path = res.data['image_url'];
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //   }
  //   return path;
  // }

  getMyApproveMeetings({
    required int skip,
    int limit = 20,
  }) async {
    List<MeetUpModel> list = [];
    // List<MeetUpModel> data = [];
    Response? res;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      try {
        res = await dio.get(
          '$baseUrl/${user.id}/meetings',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
            },
          ),
          queryParameters: {
            'status': ProfileMeetingStatus.APPROVE.name,
            'skip': skip,
            'limit': limit,
          },
        );

        if (res.statusCode == 200) {
          logger.d(res);
          if ((res.data as Map).containsKey('total_count')) {
            list = List.from(
                res.data['meetings'].map((e) => MeetUpModel.fromMap(e)));
          }
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return list;
  }

  getMyMeetings({
    required String status,
    required int skip,
    int limit = 20,
  }) async {
    CursorPagination<MeetUpModel>? cursorPagination;
    // List<MeetUpModel> data = [];
    Response? res;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      try {
        res = await dio.get(
          '$baseUrl/${user.id}/meetings',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
            },
          ),
          queryParameters: {
            'status': status,
            'skip': skip,
            'limit': limit,
          },
        );

        if (res.statusCode == 200) {
          logger.d(res);
          if ((res.data as Map).containsKey('total_count')) {
            int totalCount = res.data['total_count'];
            int count = (res.data['meetings'] as List).length;
            cursorPagination = CursorPagination<MeetUpModel>(
              meta: CursorPaginationMeta(
                count: count,
                totalCount: totalCount,
                hasMore: (skip + count < totalCount),
              ),
              data: List.from(
                  res.data['meetings'].map((e) => MeetUpModel.fromMap(e))),
            );
          }
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return cursorPagination;
  }

  updateProfile({
    required int profile_id,
    required Map<String, dynamic> data,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.put(
        '$baseUrl/$profile_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: data,
      );

      if (res.statusCode == 200) {
        logger.d(res);
        isOk = true;
        // ref.read(userMeProvider.notifier).getMe();
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  postStudentVarification({
    required String student_card,
    required int user_id,
  }) async {
    StudentVerificationModel? studentVerificationModel;
    try {
      final res = await dio.post(
        'http://$kServerIp:$kServerPort/$kServerVersion/student-card',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'student_card': student_card,
          'user_id': user_id,
        },
      );

      if (res.statusCode == 200) {
        logger.d(res);
        studentVerificationModel = StudentVerificationModel.fromMap(res.data);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return studentVerificationModel;
  }
}
