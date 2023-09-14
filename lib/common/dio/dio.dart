import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  // 인터셉터 부분
  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 요청 보낼때
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // logger.d(
    //     'options.path:${options.path}\noptions.queryParameters:${options.queryParameters.toString()}\noptions.data:${options.data.toString()}');
    logger.d('[REQ] [${options.method}] ${options.uri}');
    super.onRequest(options, handler);
  }

  // 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }
}
