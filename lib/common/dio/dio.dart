import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
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
    logger.d('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: kACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: kREFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    super.onRequest(options, handler);
  }

  // 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d([
      '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}',
      '[QUERY] ${response.requestOptions.queryParameters}',
      '[BODY] ${response.requestOptions.data}',
    ]);

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.d([
      '[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}',
      '[BODY] ${err.requestOptions.data}',
    ]);

    final refreshToken = await storage.read(key: kREFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/token/refresh';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$kServerIp:$kServerPort/$kServerVersion/token/refresh',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['access_token'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: kACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        // circular dependency error
        // A, B
        // A -> B의 친구
        // B -> A의 친구
        // A는 B의 친구구나
        // A -> B -> A -> B -> A -> B
        // ump -> dio -> ump -> dio
        ref.read(userMeProvider.notifier).logout();
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
