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
    // TODO delete
    state = null;
    //
    // bool isAutoLogin = prefs.getBool(kSpAutoLogin) ?? false;
    // if (isAutoLogin) {
    //   // 내 정보 가져오기
    //   getMe();
    // } else {
    //   state = null;
    // }
  }

  Future<UserModelBase> login({
    required String email,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
      );

      logger.d(resp);

      // await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: kACCESS_TOKEN_KEY, value: resp.access_token);

      final UserModel? userResp = await repository.getMe(resp.access_token);

      state = userResp;

      return UserModelError(message: '로그인에 실패했습니다.');
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          state = UserModelError(message: '이메일 또는 비밀번호가 일치하지 않아요');
        }
      }

      return Future.value(state);
    }
  }
}
