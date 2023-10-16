import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/secure_storage/secure_storage.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  late final FlutterSecureStorage storage;
  UsersRepository({
    required this.ref,
    required this.baseUrl,
  }) {
    dio = ref.watch(dioProvider);
    storage = ref.watch(secureStorageProvider);
  }

  Future<UserModel?> getMe() async {
    UserModel? userModel;

    final res = await dio.get(
      '$baseUrl/me',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'true',
        },
      ),
    );

    logger.d(res.toString());
    userModel = UserModel.fromMap(res.data);

    return userModel;
  }

  Future<UserModel?> getReadUser(int userId) async {
    UserModel? userModel;

    final res = await dio.get(
      '$baseUrl/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accessToken': 'false',
        },
      ),
    );

    logger.d(res.toString());
    userModel = UserModel.fromMap(res.data);

    return userModel;
  }

  getUserProfilePath(int userId) async {
    String? path;
    UserModel? userModel = await getReadUser(userId);
    if (userModel != null) {
      path = userModel.profile?.profile_photo;
    }
    return path;
  }
}
