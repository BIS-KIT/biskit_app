import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:biskit_app/user/repository/users_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/secure_storage/secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: ref.watch(authRepositoryProvider),
    repository: ref.watch(usersRepositoryProvider),
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UsersRepository repository;
  final FlutterSecureStorage storage;
  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
    //
    // bool isAutoLogin = prefs.getBool(kSpAutoLogin) ?? false;
    // if (isAutoLogin) {
    //   // 내 정보 가져오기
    //   getMe();
    // } else {
    //   state = null;
    // }
  }

  Future<void> getMe() async {
    try {
      final String? accessToken = await storage.read(key: kACCESS_TOKEN_KEY);
      final String? refreshToken = await storage.read(key: kREFRESH_TOKEN_KEY);

      if (accessToken == null || refreshToken == null) {
        state = null;
        return;
      }

      final UserModel? userModel = await repository.getMe();

      state = userModel;
    } catch (e) {
      logger.e(e.toString());
      state = null;
    }
  }

  Future<UserModelBase> login({
    required String email,
    required String password,
  }) async {
    UserModelBase? userModelBase;
    try {
      // state = UserModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
      );

      logger.d(resp);

      await storage.write(key: kACCESS_TOKEN_KEY, value: resp.access_token);
      await storage.write(key: kREFRESH_TOKEN_KEY, value: resp.refresh_token);

      userModelBase = await repository.getMe();

      state = userModelBase;
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          userModelBase = UserModelError(message: '이메일 또는 비밀번호가 일치하지 않아요');
        }
      }
    }
    return Future.value(userModelBase);
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: kREFRESH_TOKEN_KEY),
        storage.delete(key: kACCESS_TOKEN_KEY),
      ],
    );
  }
}
