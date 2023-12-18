import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/alarm_list_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
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
    getAlarmList();
  }

  Future<void> getAlarmList() async {
    final userState = ref.watch(userMeProvider);
    if (userState != null && userState is UserModel) {
      AlarmListModel? res = await ref
          .read(settingRepositoryProvider)
          .getAlarmList(user_id: userState.id);
      setState(() {
        alarmData = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (alarmData == null) {
      getAlarmList();
    }
    return DefaultLayout(
      title: '알림',
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: alarmData == null
                  ? const Center(
                      child: CustomLoading(),
                    )
                  : alarmData!.alarms.isNotEmpty
                      ? ListView.builder(
                          itemCount: alarmData!.total_count,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
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
                                            Radius.circular(8)),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alarmData!.alarms[index].title,
                                          style: getTsBody14Sb(context)
                                              .copyWith(
                                                  color: kColorContentWeak),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          alarmData!.alarms[index].content,
                                          style: getTsBody14Rg(context)
                                              .copyWith(
                                                  color: kColorContentWeak),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          dayFormat.format(DateTime.parse(
                                              alarmData!
                                                  .alarms[index].created_time)),
                                          style: getTsCaption12Rg(context)
                                              .copyWith(
                                                  color: kColorContentWeakest),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                      : Text(
                          '알림이 없어요',
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeakest),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
