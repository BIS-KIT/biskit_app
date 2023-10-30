import 'package:biskit_app/common/components/calendar_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/stepper_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/utils/date_util.dart';

class MeetUpCreateStep2Tab extends StatefulWidget {
  const MeetUpCreateStep2Tab({super.key});

  @override
  State<MeetUpCreateStep2Tab> createState() => _MeetUpCreateStep2TabState();
}

class _MeetUpCreateStep2TabState extends State<MeetUpCreateStep2Tab> {
  final DateFormat dateFormat = DateFormat('MM/dd (E) a hh:mm');
  DateTime? selectedDateTime;
  int limitNum = 2;

  @override
  initState() {
    super.initState();
    selectedDateTime = getDateTimeIntervalMin5();
    logger.d(selectedDateTime);
  }

  onTapDate() async {
    DateTime? tempDay = selectedDateTime;
    tempDay = await showBiskitBottomSheet(
      context: context,
      title: '',
      customTitleWidget: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
            ),
            Expanded(
              child: Center(
                child: Text(
                  '날짜 선택',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, null);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/ic_cancel_line_24.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            )
          ],
        ),
      ),
      contentWidget: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: CalendarWidget(
              selectedDay: tempDay,
              onDaySelected: (value) {
                tempDay = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 34,
              left: 20,
              right: 20,
            ),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(
                  context,
                  tempDay,
                );
              },
              child: const FilledButtonWidget(
                text: '선택',
                isEnable: true,
              ),
            ),
          )
        ],
      ),
    );

    logger.d(tempDay);
    if (tempDay != null) {
      setState(() {
        selectedDateTime = tempDay;
      });
      if (!mounted) return;
      DateTime tempTime = selectedDateTime!.add(const Duration(hours: 2));
      final time = await showTimeBottomSheet(
        context: context,
        time: tempTime,
      );
      if (time != null) {
        setState(() {
          selectedDateTime = time;
        });
      }
    }
  }

  void onClickMinus() {
    if (limitNum <= 2) return;
    setState(() {
      limitNum = limitNum - 1;
    });
  }

  void onClickPlus() {
    if (limitNum >= 10) return;
    setState(() {
      limitNum = limitNum + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Text(
              '언제 만날까요?',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: onTapDate,
              child: OutlinedButtonWidget(
                text: selectedDateTime == null
                    ? ''
                    : dateFormat.format(selectedDateTime!),
                height: 52,
                isEnable: true,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 48,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최대 인원을 알려주세요',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StepperWidget(
              onClickMinus: onClickMinus,
              onClickPlus: onClickPlus,
              value: limitNum,
            )
          ],
        ),
      ],
    );
  }
}
