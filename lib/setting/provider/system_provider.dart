import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';

final systemProvider =
    StateNotifierProvider<SystemStateNotifier, UserSystemModelBase?>((ref) {
  return SystemStateNotifier(
    ref: ref,
    repository: ref.watch(settingRepositoryProvider),
  );
});

class SystemStateNotifier extends StateNotifier<UserSystemModelBase?> {
  final Ref ref;
  final SettingRepository repository;
  SystemStateNotifier({
    required this.ref,
    required this.repository,
  }) : super(UserSystemModelLoading()) {
    getUserSystem();
  }
  Future<void> getUserSystem() async {
    try {
      UserModelBase? userState = ref.watch(userMeProvider);
      UserSystemModel? res =
          await ref.read(settingRepositoryProvider).getUserSystem(
                userId: (userState as UserModel).id,
              );
      state = res;
    } catch (e) {
      state = UserSystenModelError(
        message: e.toString(),
      );
      logger.e(e.toString());
    }
  }

  Future<void> updateUserOSLanguage({systemId, selectedLang}) async {
    try {
      UserSystemModel? res = await ref
          .read(settingRepositoryProvider)
          .updateUserOSLanguage(systemId: systemId, systemLang: selectedLang);
      logger.d(res);
      state = res;
    } finally {}
  }

  Future<void> updateUserAlarm({systemId, mainAlarm, etcAlarm}) async {
    try {
      UserSystemModel? res = await ref
          .read(settingRepositoryProvider)
          .updateUserAlarm(
              systemId: systemId, mainAlarm: mainAlarm, etcAlarm: etcAlarm);
      logger.d(res);
      state = res;
    } finally {}
  }

  Future<bool> getCriticalNotification() async {
    bool isValue = false;
    UserModelBase? userState = ref.watch(userMeProvider);
    UserSystemModel? res =
        await ref.read(settingRepositoryProvider).getUserSystem(
              userId: (userState as UserModel).id,
            );
    if (res is UserSystemModel) {
      isValue = res.main_alarm;
    }
    return isValue;
  }

  Future<bool> getGeneralNotification() async {
    bool isValue = false;
    UserModelBase? userState = ref.watch(userMeProvider);
    UserSystemModel? res =
        await ref.read(settingRepositoryProvider).getUserSystem(
              userId: (userState as UserModel).id,
            );
    if (res is UserSystemModel) {
      isValue = res.etc_alarm;
    }
    return isValue;
  }
}
