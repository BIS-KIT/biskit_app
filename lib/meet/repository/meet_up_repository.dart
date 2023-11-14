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
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
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

  createMeetUp(CreateMeetUpModel createMeetUpModel) async {
    Response? res;
    try {
      res = await dio.post(
        '$baseUrl/create',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: createMeetUpModel.toMap(),
      );

      if (res.statusCode == 200) {
        logger.d(res);
        return true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return false;
  }

  Future<MeetUpDetailModel> getMeetUpDetail(int meetUpId) async {
    MeetUpDetailModel meetUpDetailModel;
    final res = await dio.get(
      '$baseUrl/$meetUpId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    // if (res.statusCode == 200) {
    logger.d(res);
    meetUpDetailModel = MeetUpDetailModel.fromMap(res.data);

    return meetUpDetailModel;
    // }
  }

  createReview({
    required int meetingId,
    required String imageUrl,
    required String context,
  }) async {
    Response? res;
    final user = ref.watch(userMeProvider);
    if (user is UserModel) {
      try {
        res = await dio.post(
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
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    return res;
  }
}
