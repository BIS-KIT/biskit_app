import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final utilRepositoryProvider = Provider<UtilRepository>(
  (ref) => UtilRepository(
    ref: ref,
    dio: ref.watch(dioProvider),
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
  ),
);

class UtilRepository {
  final Ref ref;
  final Dio dio;
  final String baseUrl;
  UtilRepository({
    required this.ref,
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
}
