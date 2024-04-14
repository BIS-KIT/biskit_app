import 'package:biskit_app/alarm/model/alarm_list_model.dart';
import 'package:biskit_app/alarm/model/alarm_model.dart';
import 'package:biskit_app/alarm/provider/alarm_provider.dart';
import 'package:biskit_app/alarm/repository/alarm_repository.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/setting/view/warning_history_screen.dart';
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
  UserModelBase? userState;
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
    userState = ref.read(userMeProvider);
    if (userState != null && userState is UserModel) {
      AlarmListModel? res = await ref
          .read(alarmRepositoryProvider)
          .getAlarmList(user_id: (userState as UserModel).id);
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
      setState(() {});
    }
  }

  Map<String, dynamic> getNotificationImageAndBg(String? category) {
    if (category == 'Meeting') {
      return {
        'imagePath': 'assets/icons/ic_person_fill_24.svg',
        'bgColor': kColorBgElevation2,
        'iconColor': kColorContentWeakest,
      };
    }
    if (category == 'Notice') {
      return {
        'imagePath': 'assets/icons/ic_megaphone_fill_24.svg',
        'bgColor': kColorBgSecondaryWeak,
        'iconColor': kColorContentSecondary,
      };
    }
    if (category == 'Report') {
      return {
        'imagePath': 'assets/icons/ic_siren_fill_24.svg',
        'bgColor': kColorBgError,
        'iconColor': kColorContentError,
      };
    }
    // 아무것도 해당 안 될 경우
    return {
      'imagePath': 'assets/icons/ic_person_fill_24.svg',
      'bgColor': kColorBgElevation2,
      'iconColor': kColorContentWeakest,
    };
  }

  void pageRouting(AlarmModel alarm) {
    if (alarm.obj_name == 'Meeting') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MeetUpDetailScreen(meetupId: alarm.obj_id!, userModel: userState),
        ),
      );
    }
    if (alarm.obj_name == 'Report') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WarningHistoryScreen(),
        ),
      );
    }
    // if (alarm.obj_name == 'Notice') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           AnnouncementDetailScreen(notice:),

    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (alarmData != null && alarmData!.alarms.isEmpty) {
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
                        Map<String, dynamic> imageAndBg =
                            getNotificationImageAndBg(
                                alarmData!.alarms[index].obj_name);
                        return GestureDetector(
                          onTap: () {
                            pageRouting(alarmData!.alarms[index]);
                          },
                          child: Container(
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
                                    decoration: BoxDecoration(
                                      color: imageAndBg['bgColor'],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      imageAndBg['imagePath'],
                                      width: 24,
                                      height: 24,
                                      colorFilter: ColorFilter.mode(
                                        imageAndBg['iconColor'],
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
                                          style:
                                              getTsBody14Sb(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          alarmData!.alarms[index].content,
                                          style:
                                              getTsBody14Rg(context).copyWith(
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
                                          style: getTsCaption12Rg(context)
                                              .copyWith(
                                            color: kColorContentWeakest,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
