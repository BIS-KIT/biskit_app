import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetUpRepositoryProvider = Provider<MeetUpRepository>((ref) {
  return MeetUpRepository(
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/meeting',
  );
});

class MeetUpRepository {
  final Dio dio;
  final String baseUrl;
  MeetUpRepository({
    required this.dio,
    required this.baseUrl,
  });

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
