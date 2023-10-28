import 'package:biskit_app/common/components/calendar_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/stepper_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpCreateStep2Tab extends StatefulWidget {
  const MeetUpCreateStep2Tab({super.key});

  @override
  State<MeetUpCreateStep2Tab> createState() => _MeetUpCreateStep2TabState();
}

class _MeetUpCreateStep2TabState extends State<MeetUpCreateStep2Tab> {
  DateTime selectedDay = DateTime.now();
  int limitNum = 0;

  @override
  Widget build(BuildContext context) {
    String weekDay =
        DateFormat('E', context.locale.toString()).format(selectedDay);
    String amOrPm =
        DateFormat('a', context.locale.toString()).format(selectedDay);
    String hourInAmOrPm =
        DateFormat('K', context.locale.toString()).format(selectedDay);

    // TODO: 날짜 선택 후 x 버튼 누르면 변경값 적용 안 되도록 로직 수정해야함
    void onDaySelected(DateTime day) {
      setState(() {
        selectedDay = day;
      });
    }

    void onClickMinus() {
      if (limitNum <= 0) return;
      setState(() {
        limitNum = limitNum - 1;
      });
    }

    void onClickPlus() {
      setState(() {
        limitNum = limitNum + 1;
      });
    }

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
            InkWell(
              onTap: () {
                showBiskitBottomSheet(
                    context: context,
                    title: '',
                    customTitleWidget: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 0),
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
                              Navigator.pop(context);
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
                              left: 20, right: 20, bottom: 20),
                          child: CalendarWidget(
                            selectedDay: selectedDay,
                            onDaySelected: onDaySelected,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 12, bottom: 34, left: 20, right: 20),
                          child: FilledButtonWidget(text: '선택', isEnable: true),
                        )
                      ],
                    ));
              },
              child: OutlinedButtonWidget(
                text:
                    '${selectedDay.month}/${selectedDay.day} ($weekDay) $amOrPm $hourInAmOrPm:${selectedDay.minute}',
                // text: '10/21 (목) 오후 6:00',
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
                value: limitNum)
          ],
        ),
      ],
    );
  }
}
