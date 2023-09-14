import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/dio/dio.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(
    ref: ref,
    baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion/users',
  );
});

class UsersRepository {
  final Ref ref;
  final String baseUrl;
  late final Dio dio;
  UsersRepository({
    required this.ref,
    required this.baseUrl,
  }) {
    dio = ref.watch(dioProvider);
  }

  Future<UserModel?> getMe(String token) async {
    UserModel? userModel;

    final res = await dio.get(
      '$baseUrl/me',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      queryParameters: {
        'token': token,
      },
    );

    logger.d(res.toString());

    return userModel;
  }
}
