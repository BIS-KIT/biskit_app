import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/dio/dio.dart';
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
}
