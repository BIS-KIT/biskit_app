import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class MeetUpCreateStep1Tab extends StatelessWidget {
  const MeetUpCreateStep1Tab({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> subjectList = [
      '식사',
      '카페',
      '액티비티',
      '언어교환',
      '스터디',
      '문화*예술',
      '취미',
      '여행',
    ];
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
              '무엇을 할건가요?',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                ...subjectList.map(
                  (e) => ChipWidget(
                    text: e,
                    isSelected: false,
                    onClickSelect: () {},
                  ),
                ),
                ChipWidget(
                  text: '직접입력',
                  isSelected: false,
                  onTapAdd: () {},
                  onTapDelete: null,
                  onClickSelect: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 48,
            ),
            Text(
              '어디서 만날까요?',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const OutlinedButtonWidget(
              height: 52,
              text: '장소 선택',
              isEnable: true,
            ),
          ],
        ),
      ],
    );
  }
}
