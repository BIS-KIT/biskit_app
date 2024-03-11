import 'package:biskit_app/alarm/model/alarm_list_model.dart';
import 'package:biskit_app/alarm/provider/alarm_provider.dart';
import 'package:biskit_app/alarm/repository/alarm_repository.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  AlarmListModel? alarmData;
  final DateFormat dayFormat = DateFormat('MM/dd hh:mm', 'ko');

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getAlarmList();
    await readAlarms();
  }

  Future<void> getAlarmList() async {
    final userState = ref.watch(userMeProvider);
    if (userState != null && userState is UserModel) {
      AlarmListModel? res = await ref
          .read(alarmRepositoryProvider)
          .getAlarmList(user_id: userState.id);
      setState(() {
        alarmData = res;
      });
    }
  }

  Future<void> readAlarms() async {
    if (alarmData != null) {
      List<Future<void>> readFutures = [];

      for (var alarm in alarmData!.alarms) {
        if (!alarm.is_read) {
          readFutures.add(
            ref.read(alarmRepositoryProvider).readAlarm(alarm_id: alarm.id),
          );
        }
      }

      await Future.wait(readFutures);

      final userState = ref.read(userMeProvider);
      if (userState != null && userState is UserModel) {
        AlarmListModel? updatedAlarms = await ref
            .read(alarmRepositoryProvider)
            .getAlarmList(user_id: userState.id);
        if (updatedAlarms != null) {
          ref.watch(alarmProvider.notifier).readAlarm(updatedAlarms);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (alarmData == null) {
      initializeData();
      return const Center(
        child: CustomLoading(),
      );
    }

    if (alarmData!.alarms.isEmpty) {
      return DefaultLayout(
        title: 'alarmListScreen.header'.tr(),
        child: Center(
            child: Text(
          'alarmListScreen.noData'.tr(),
          style: getTsBody16Rg(context).copyWith(color: kColorContentWeakest),
        )),
      );
    }

    return DefaultLayout(
      title: 'alarmListScreen.header'.tr(),
      child: Column(
        children: [
          Expanded(
            child: (alarmData == null)
                ? const CustomLoading()
                : Center(
                    child: ListView.builder(
                      itemCount: alarmData!.alarms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: alarmData!.alarms[index].is_read
                                ? kColorBgElevation1
                                : kColorBgDefault,
                            border: const Border(
                              bottom: BorderSide(
                                width: 1,
                                color: kColorBorderWeak,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: kColorBgSecondaryWeak,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_megaphone_fill_24.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      kColorContentSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alarmData!.alarms[index].title,
                                        style: getTsBody14Sb(context).copyWith(
                                          color: kColorContentWeak,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        alarmData!.alarms[index].content,
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeak,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        dayFormat.format(
                                          DateTime.parse(
                                            alarmData!
                                                .alarms[index].created_time,
                                          ),
                                        ),
                                        style:
                                            getTsCaption12Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
