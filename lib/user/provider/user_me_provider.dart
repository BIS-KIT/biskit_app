import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  return UserMeStateNotifier(
    repository: ref.watch(authRepositoryProvider),
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository repository;
  UserMeStateNotifier({
    required this.repository,
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
}
