import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => ReviewRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/review',
  ),
);

class ReviewRepository {
  final Ref ref;
  final Dio dio;
  final String baseUrl;
  ReviewRepository({
    required this.ref,
    required this.dio,
    required this.baseUrl,
  });

  deleteReview(int id) async {
    bool isOk = false;
    try {
      final res = await dio.delete(
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
        isOk = true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return isOk;
  }

  getReview(int id) async {
    ResReviewModel? model;
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
        model = ResReviewModel.fromMap(res.data);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return model;
  }
}
