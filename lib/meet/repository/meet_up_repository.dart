// ignore_for_file: non_constant_identifier_names

import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/model/pagination_params.dart';
import 'package:biskit_app/common/repository/base_pagination_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/model/meet_up_filter_model.dart';
import 'package:biskit_app/meet/model/meet_up_list_order.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/meet_up_request_model.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
import 'package:biskit_app/profile/provider/profile_meeting_provider.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetUpRepositoryProvider = Provider<MeetUpRepository>((ref) {
  return MeetUpRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/meeting',
  );
});

class MeetUpRepository implements IBasePaginationRepository<MeetUpModel> {
  final Ref ref;
  final Dio dio;
  final String baseUrl;
  MeetUpRepository({
    required this.ref,
    required this.dio,
    required this.baseUrl,
  });

  // Future<List<MeetUpModel>> getMeetings({
  //   int skip = 0,
  //   int limit = 20,
  // }) async {
  //   List<MeetUpModel> data = [];

  //   return data;
  // }

  paginateCount(List<MeetUpFilterGroup> filter) async {
    int? totalCount;
    List<String> timeFilter = [];
    List<int> tagFilter = [];
    List<int> topicsFilter = [];
    String nationalFilter = 'ALL';

    for (var f in filter) {
      if (f.filterType == MeetUpFilterType.tag) {
        // tag
        tagFilter.addAll(f.filterList
            .where((element) => element.isSeleted)
            .toList()
            .map((e) => int.parse(e.value)));
      } else if (f.filterType == MeetUpFilterType.topic) {
        // topic
        topicsFilter.addAll(f.filterList
            .where((element) => element.isSeleted)
            .toList()
            .map((e) => int.parse(e.value)));
      } else if (f.filterType == MeetUpFilterType.national) {
        // 주최자 국적
        List<MeetUpFilterModel> temp =
            f.filterList.where((element) => element.isSeleted).toList();
        if (temp.length == 1) {
          nationalFilter = temp[0].value;
        }
      } else {
        // 나머지 시간 관련 필터
        timeFilter.addAll(f.filterList
            .where((element) => element.isSeleted)
            .toList()
            .map((e) => e.value));
      }
    }
    try {
      Response res = await dio.get(
        '${baseUrl}s',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'is_count_only': true,
          'tags_ids': tagFilter,
          'topics_ids': topicsFilter,
          'creator_nationality': nationalFilter,
          'time_filters': timeFilter,
        },
      );
      // logger.d(res.data);
      if (res.statusCode == 200) {
        if ((res.data as Map).containsKey('total_count')) {
          totalCount = res.data['total_count'];
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return totalCount;
  }

  @override
  Future<CursorPagination<MeetUpModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
    Object? orderBy,
    Object? filter,
  }) async {
    List<MeetUpModel> data = [];
    int totalCount = 0;
    int count = 0;

    int limit = paginationParams!.count!;
    int skip = paginationParams.skip ?? 0;
    // MeetUpOrderState orderBy =
    //     (paginationParams.orderBy as MeetUpOrderState?) ??
    //         MeetUpOrderState.created_time;
    List<String> timeFilter = [];
    List<int> tagFilter = [];
    List<int> topicsFilter = [];
    String nationalFilter = 'ALL';

    if (filter != null) {
      // filtering =
      //     (filter as List<MeetUpFilterModel>).map((e) => e.value).toList();

      for (var f in (filter as List<MeetUpFilterGroup>)) {
        if (f.filterType == MeetUpFilterType.tag) {
          // tag
          tagFilter.addAll(f.filterList
              .where((element) => element.isSeleted)
              .toList()
              .map((e) => int.parse(e.value)));
        } else if (f.filterType == MeetUpFilterType.topic) {
          // topic
          topicsFilter.addAll(f.filterList
              .where((element) => element.isSeleted)
              .toList()
              .map((e) => int.parse(e.value)));
        } else if (f.filterType == MeetUpFilterType.national) {
          // 주최자 국적
          List<MeetUpFilterModel> temp =
              f.filterList.where((element) => element.isSeleted).toList();
          if (temp.length == 1) {
            nationalFilter = temp[0].value;
          }
        } else {
          // 나머지 시간 관련 필터
          timeFilter.addAll(f.filterList
              .where((element) => element.isSeleted)
              .toList()
              .map((e) => e.value));
        }
      }
    }
    logger.d('tagFilter>>>$tagFilter');

    try {
      Response res = await dio.get(
        '${baseUrl}s',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'order_by':
              ((orderBy as MeetUpOrderState?) ?? MeetUpOrderState.created_time)
                  .name,
          'skip': skip,
          'limit': limit,
          'tags_ids': tagFilter,
          'topics_ids': topicsFilter,
          'creator_nationality': nationalFilter,
          'time_filters': timeFilter,
        },
      );
      // logger.d(res.data);
      if (res.statusCode == 200) {
        if ((res.data as Map).containsKey('total_count')) {
          totalCount = res.data['total_count'];
          count = (res.data['meetings'] as List).length;
          data = List.from((res.data['meetings'] as List)
              .map((e) => MeetUpModel.fromMap(e)));
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }

    return CursorPagination<MeetUpModel>(
      meta: CursorPaginationMeta(
        count: count,
        totalCount: totalCount,
        hasMore: (skip + count < totalCount),
      ),
      data: data,
    );
  }

  Future<List<MeetUpModel>?> getMeetings({
    required int skip,
    int limit = 20,
  }) async {
    List<MeetUpModel>? meetings;
    try {
      Response res = await dio.get(
        '${baseUrl}s',
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
      // logger.d(res.data);
      if (res.statusCode == 200) {
        if ((res.data as Map).containsKey('total_count')) {
          meetings = List.from((res.data['meetings'] as List)
              .map((e) => MeetUpModel.fromMap(e)));
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return meetings;
  }

  Future<int?> createMeetUp(CreateMeetUpModel createMeetUpModel) async {
    int? createMeetupId;
    Response? res;
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
        data: createMeetUpModel.toMap(),
      );

      if (res.statusCode == 200) {
        logger.d(res);
        createMeetupId = res.data['id'];
        // return true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return createMeetupId;
  }

  Future<MeetUpDetailModel> getMeetUpDetail(int meetUpId) async {
    MeetUpDetailModel meetUpDetailModel;
    final res = await dio.get(
      '$baseUrl/$meetUpId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
    );
    // if (res.statusCode == 200) {
    logger.d(res);
    meetUpDetailModel = MeetUpDetailModel.fromMap(res.data);

    return meetUpDetailModel;
    // }
  }

  Future<int?> createReview({
    required int meetingId,
    required String imageUrl,
    required String context,
  }) async {
    int? id;
    // ResReviewModel? model;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      try {
        Response? res = await dio.post(
          '$baseUrl/$meetingId/reviews',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'accessToken': 'true',
            },
          ),
          data: {
            'context': context,
            'image_url': imageUrl,
            'creator_id': user.id,
          },
        );

        if (res.statusCode == 200) {
          logger.d(res);
          id = res.data['id'];
          // model = ResReviewModel.fromMap(res.data);
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return id;
  }

  getMeetingAllReviews({
    required int skip,
    required int limit,
    required int userId,
  }) async {
    CursorPagination<ResReviewModel>? cursorPagination;
    // List<ResReviewModel> list = [];
    // final user = ref.watch(userMeProvider);
    // if (user is UserModel) {
    try {
      final res = await dio.get(
        '$baseUrl/reviews/$userId',
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

      if (res.statusCode == 200) {
        // logger.d(res);
        if ((res.data as Map).containsKey('total_count')) {
          int totalCount = res.data['total_count'];
          int count = (res.data['reviews'] as List).length;
          cursorPagination = CursorPagination<ResReviewModel>(
            meta: CursorPaginationMeta(
              count: count,
              totalCount: totalCount,
              hasMore: (skip + count < totalCount),
            ),
            data: List.from(
                res.data['reviews'].map((e) => ResReviewModel.fromMap(e))),
          );
        }
      }
    } catch (e) {
      logger.e(e.toString());
    }
    // }
    return cursorPagination;
  }

  getMeeting(int id) async {
    try {
      final res = await dio.get(
        '$baseUrl/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );

      if (res.statusCode == 200) {
        logger.d(res);
        return MeetUpModel.fromMap(res.data);
        // list = List.from(res.data.map((e) => ResReviewModel.fromMap(e)));
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  postJoinRequest({
    required int meeting_id,
    required int user_id,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.post(
        '$baseUrl/join/request',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: {
          'meeting_id': meeting_id,
          'user_id': user_id,
        },
      );

      logger.d(res);
      if (res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  /// 모임 참가 신청 리스트
  Future<List<MeetUpRequestModel>> getMeetingRequests(int id) async {
    List<MeetUpRequestModel> list = [];
    try {
      final res = await dio.get(
        '${baseUrl}s/$id/requests',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'skip': 0,
          'limit': 20,
        },
      );

      if (res.statusCode == 200) {
        logger.d(res);
        list = List.from(
            res.data['requests'].map((e) => MeetUpRequestModel.fromMap(e)));
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return list;
  }

  postJoinReject(int id) async {
    bool isOk = false;
    try {
      final res = await dio.post(
        '$baseUrl/join/reject',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'obj_id': id,
        },
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  postJoinApprove({
    required int id,
    required String chatRoomUid,
    required int userId,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.post(
        '$baseUrl/join/approve',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        queryParameters: {
          'obj_id': id,
        },
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        isOk = true;

        // 채팅방 join
        await ref.read(chatRepositoryProvider).inChatRoomUser(
              chatRoomUid: chatRoomUid,
              userId: userId,
            );
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  deleteMeeting(MeetUpDetailModel meetUpDetailModel) async {
    bool isOk = false;
    try {
      final res = await dio.delete(
        '$baseUrl/${meetUpDetailModel.id}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        isOk = true;

        // 채팅방 삭제
        ref.read(chatRepositoryProvider).deleteChatRoom(
              chatRoomUid: meetUpDetailModel.chat_id,
            );
        // 미팅 리스트 삭제된 미팅 삭제
        ref.read(meetUpFilterProvider.notifier).paginate();
        // 프로필 미팅 리스트 조회
        ref.read(profileMeetingProvider.notifier).fetch();
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  postExitMeeting({
    required int user_id,
    required int meeting_id,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.post(
        '$baseUrl/$meeting_id/user/$user_id/exit',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  putUpdateMeetUp({
    required int id,
    required CreateMeetUpModel model,
  }) async {
    bool isOk = false;
    try {
      final res = await dio.put(
        '$baseUrl/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
        data: model.toMap(),
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        isOk = true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  getCheckMeetingRequestStatus({
    required int meeting_id,
    required int user_id,
  }) async {
    String? status;
    try {
      final res = await dio.get(
        '$baseUrl/$meeting_id/user/$user_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'accessToken': 'true',
          },
        ),
      );

      logger.d(res);
      if (res.statusCode == 201 || res.statusCode == 200) {
        status = res.data['status'];
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        status = null;
      } else {
        logger.e(e.toString());
      }
    }
    return status;
  }
}
