import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationSettingScreen extends ConsumerStatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  ConsumerState<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends ConsumerState<NotificationSettingScreen> {
  @override
  Widget build(BuildContext context) {
    // if (criticalNotification == null || generalNotification == null) {
    //   setState(() {
    //     criticalNotification =
    //         (ref.watch(systemProvider) as UserSystemModel).main_alarm;
    //     generalNotification =
    //         (ref.watch(systemProvider) as UserSystemModel).etc_alarm;
    //   });
    // }
    return DefaultLayout(
        title: 'setNotificationScreen.header'.tr(),
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        onTapLeading: () async {
          await ref.read(systemProvider.notifier).updateUserAlarm(
                systemId: (ref.watch(systemProvider) as UserSystemModel).id,
                mainAlarm: criticalNotification,
                etcAlarm: generalNotification,
              );
          if (mounted) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'setNotificationScreen.importantNotification.title'
                              .tr(),
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'setNotificationScreen.importantNotification.description'
                              .tr(),
                          style: getTsBody14Rg(context)
                              .copyWith(color: kColorContentWeakest),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CupertinoSwitch(
                    value: criticalNotification,
                    activeColor: kColorBgPrimaryStrong,
                    onChanged: (bool? value) async {
                      if (criticalNotification == false) {
                        final PermissionStatus status =
                            await Permission.notification.request();
                        if (!mounted) return;
                        if (!status.isGranted) {
                          showConfirmModal(
                            context: context,
                            title:
                                'setNotificationScreen.setNotificationModal.title'
                                    .tr(),
                            content:
                                'setNotificationScreen.setNotificationModal.subtitle'
                                    .tr(),
                            leftButton:
                                'setNotificationScreen.setNotificationModal.cancel'
                                    .tr(),
                            leftCall: () {
                              Navigator.pop(context);
                            },
                            rightButton:
                                'setNotificationScreen.setNotificationModal.allow'
                                    .tr(),
                            rightCall: () async {
                              // 알림 설정으로 이동
                              openAppSettings();

                              Navigator.pop(context);
                            },
                            rightBackgroundColor: kColorBgPrimary,
                            rightTextColor: kColorContentOnBgPrimary,
                          );
                        }
                        setState(() {
                          criticalNotification = true;
                        });
                      } else {
                        setState(() {
                          criticalNotification = false;
                        });
                      }
                      await ref.read(systemProvider.notifier).updateUserAlarm(
                            systemId:
                                (ref.watch(systemProvider) as UserSystemModel)
                                    .id,
                            mainAlarm: criticalNotification,
                            etcAlarm: generalNotification,
                          );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'setNotificationScreen.etcNotification.title'.tr(),
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'setNotificationScreen.etcNotification.description'
                              .tr(),
                          style: getTsBody14Rg(context)
                              .copyWith(color: kColorContentWeakest),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CupertinoSwitch(
                    value: generalNotification,
                    activeColor: kColorBgPrimaryStrong,
                    onChanged: (bool? value) async {
                      if (generalNotification == false) {
                        final PermissionStatus status =
                            await Permission.notification.request();
                        if (!mounted) return;
                        if (!status.isGranted) {
                          await showConfirmModal(
                            context: context,
                            title:
                                'setNotificationScreen.setNotificationModal.title'
                                    .tr(),
                            content:
                                'setNotificationScreen.setNotificationModal.subtitle'
                                    .tr(),
                            leftButton:
                                'setNotificationScreen.setNotificationModal.cancel'
                                    .tr(),
                            leftCall: () {
                              Navigator.pop(context);
                            },
                            rightButton:
                                'setNotificationScreen.setNotificationModal.allow'
                                    .tr(),
                            rightCall: () async {
                              // 알림 설정으로 이동
                              openAppSettings();
                              Navigator.pop(context);
                            },
                            rightBackgroundColor: kColorBgPrimary,
                            rightTextColor: kColorContentOnBgPrimary,
                          );
                        }
                        setState(() {
                          generalNotification = true;
                        });
                      } else {
                        setState(() {
                          generalNotification = false;
                        });
                      }
                      await ref.read(systemProvider.notifier).updateUserAlarm(
                            systemId:
                                (ref.watch(systemProvider) as UserSystemModel)
                                    .id,
                            mainAlarm: criticalNotification,
                            etcAlarm: generalNotification,
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
