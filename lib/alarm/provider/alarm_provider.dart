import 'package:biskit_app/alarm/model/alarm_list_model.dart';
import 'package:biskit_app/alarm/model/alarm_model.dart';
import 'package:biskit_app/alarm/repository/alarm_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmProvider =
    StateNotifierProvider<AlarmStateNotifier, AlarmListModelBase?>((ref) {
  return AlarmStateNotifier(
    ref: ref,
    repository: ref.watch(alarmRepositoryProvider),
  );
});

class AlarmStateNotifier extends StateNotifier<AlarmListModelBase?> {
  final Ref ref;
  final AlarmRepository repository;
  AlarmStateNotifier({
    required this.ref,
    required this.repository,
  }) : super(AlarmListModelLoading()) {
    getAlarmList();
  }

  Future<void> getAlarmList() async {
    try {
      UserModelBase? userState = ref.watch(userMeProvider);
      AlarmListModel? res =
          await ref.read(alarmRepositoryProvider).getAlarmList(
                user_id: (userState as UserModel).id,
              );
      state = res;
    } catch (e) {
      state = AlarmListModelError(
        message: e.toString(),
      );
      logger.e(e.toString());
    }
  }

  readAlarm(AlarmListModel updatedAlarms) async {
    state = updatedAlarms;
  }
}
