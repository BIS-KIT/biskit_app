import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter/cupertino.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool criticalNotification = false;
  bool generalNotification = false;
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '알림',
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
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
                          '중요알림',
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '모임에 필수적인 알림을 보내드려요',
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
                    onChanged: (bool? value) {
                      if (criticalNotification == false) {
                        showConfirmModal(
                          context: context,
                          title: '기기의 알림 설정이 꺼져있어요',
                          content: '휴대폰 설정 > 알림 > BISKIT에서\n알림을 허용해주세요',
                          leftButton: '취소',
                          leftCall: () {
                            Navigator.pop(context);
                          },
                          rightButton: '알림 켜기',
                          rightCall: () {
                            // TODO: 알림 설정으로 이동
                            setState(() {
                              criticalNotification = true;
                            });
                            Navigator.pop(context);
                          },
                          rightBackgroundColor: kColorBgPrimary,
                          rightTextColor: kColorContentOnBgPrimary,
                        );
                      } else {
                        setState(() {
                          criticalNotification = false;
                        });
                      }
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
                          '기타알림',
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeak),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '공지/이벤트 알림 등을 보내드려요',
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
                    onChanged: (bool? value) {
                      if (generalNotification == false) {
                        showConfirmModal(
                          context: context,
                          title: '기기의 알림 설정이 꺼져있어요',
                          content: '휴대폰 설정 > 알림 > BISKIT에서\n알림을 허용해주세요',
                          leftButton: '취소',
                          leftCall: () {
                            Navigator.pop(context);
                          },
                          rightButton: '알림 켜기',
                          rightCall: () {
                            // TODO: 알림 설정으로 이동
                            setState(() {
                              generalNotification = true;
                            });
                            Navigator.pop(context);
                          },
                          rightBackgroundColor: kColorBgPrimary,
                          rightTextColor: kColorContentOnBgPrimary,
                        );
                      } else {
                        setState(() {
                          generalNotification = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
