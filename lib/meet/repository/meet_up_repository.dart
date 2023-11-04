import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/model/pagination_params.dart';
import 'package:biskit_app/common/repository/base_pagination_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetUpRepositoryProvider = Provider<MeetUpRepository>((ref) {
  return MeetUpRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/meeting',
  );
});

class MeetUpRepository implements IBasePaginationRepository<MeetUpModel> {
  final Dio dio;
  final String baseUrl;
  MeetUpRepository({
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

  @override
  Future<CursorPagination<MeetUpModel>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  }) async {
    logger.d(paginationParams);
    List<MeetUpModel> data = [];
    int totalCount = 0;
    int count = 0;

    int limit = paginationParams!.count!;
    int skip = paginationParams.skip ?? 0;

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
          // 'order_by': '',
          'skip': skip,
          'limit': limit,
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
        hasMore: skip + count < totalCount,
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
}
