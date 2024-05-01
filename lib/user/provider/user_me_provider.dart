import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/provider/root_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:biskit_app/user/repository/users_repository.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/secure_storage/secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
    repository: ref.watch(usersRepositoryProvider),
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final Ref ref;
  final AuthRepository authRepository;
  final UsersRepository repository;
  final FlutterSecureStorage storage;
  UserMeStateNotifier({
    required this.ref,
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

      logger.d(['accessToken:$accessToken', 'refreshToken:$refreshToken']);

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

  Future<void> signUpGetMe({
    required String accessToken,
    required String refreshToken,
  }) async {
    await storage.write(key: kACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: kREFRESH_TOKEN_KEY, value: refreshToken);
    await getMe();
  }

  Future<UserModelBase?> login({
    String? email,
    String? password,
    SnsType? snsType,
    String? snsId,
  }) async {
    UserModelBase? userModelBase;
    try {
      // state = UserModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
        snsType: snsType?.name,
        snsId: snsId,
      );

      logger.d(resp);

      await storage.write(key: kACCESS_TOKEN_KEY, value: resp.access_token);
      await storage.write(key: kREFRESH_TOKEN_KEY, value: resp.refresh_token);

      userModelBase = await repository.getMe();

      state = userModelBase;
    } on DioException catch (e) {
      logger.e(e.toString());
      if (e.response != null) {
        logger.d(e.response!.data.toString());
        if (e.response!.statusCode == 400) {
          if (snsType == null) {
            if (['Incorrect credentials', 'User Not Found']
                .contains(e.response!.data['detail'])) {
              userModelBase =
                  UserModelError(message: 'emailLoginScreen.errorToast'.tr());
            } else if (e.response!.data['detail'] ==
                'Account in the process of withdrawal') {
              userModelBase = UserModelError(
                  message: 'emailLoginScreen.deletedAccount'.tr());
            } else {
              userModelBase = null;
            }
          } else {
            if ('User Not Found' == e.response!.data['detail']) {
              userModelBase = null;
            } else {
              userModelBase =
                  UserModelError(message: 'emailLoginScreen.errorToast'.tr());
            }
          }
        }
      }
    }
    return userModelBase;
  }

  Future<void> logout() async {
    state = null;
    ref.read(rootProvider.notifier).init();

    await Future.wait(
      [
        storage.delete(key: kREFRESH_TOKEN_KEY),
        storage.delete(key: kACCESS_TOKEN_KEY),
      ],
    );
  }

  Future<void> deleteUser() async {
    if (state is UserModel) {
      await authRepository.deleteUser((state as UserModel).id);
      state = null;
    }
  }
}
