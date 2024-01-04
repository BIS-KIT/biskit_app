import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

import 'filled_button_widget.dart';

class TimePickerWidget extends StatefulWidget {
  final DateTime time;
  final Function() onTapBack;
  const TimePickerWidget({
    Key? key,
    required this.time,
    required this.onTapBack,
  }) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  DateTime selectedTime = DateTime.now();
  bool isButtonEnable = true;

  @override
  void initState() {
    selectedTime = widget.time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      child: Container(
        height: 365,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: kColorBgDefault,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onTapBack();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/icons/ic_arrow_back_ios_line_24.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      '시간 선택',
                      textAlign: TextAlign.center,
                      style: getTsHeading18(context).copyWith(
                        color: kColorContentDefault,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
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
            Expanded(
              child: Container(
                height: 189,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: CupertinoDatePicker(
                  backgroundColor: kColorBgDefault,
                  initialDateTime: selectedTime,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  onDateTimeChanged: (value) {
                    logger.d(value);
                    if (value.isBefore(DateTime.now())) {
                      setState(() {
                        isButtonEnable = false;
                      });
                    } else {
                      setState(() {
                        isButtonEnable = true;
                      });
                    }
                    selectedTime = value;
                  },
                  minuteInterval: 5,
                ),
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
                onTap: () {
                  if (isButtonEnable) {
                    Navigator.pop(context, selectedTime);
                  }
                },
                child: FilledButtonWidget(
                  text: '완료',
                  isEnable: isButtonEnable,
                  backgroundColor: kColorBgPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
