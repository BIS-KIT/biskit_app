import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/progress_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class MeetCreateStep1 extends StatelessWidget {
  const MeetCreateStep1({super.key});

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
    return DefaultLayout(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            const ProgressBarWidget(
              isFirstDone: true,
              isSecondDone: false,
              isThirdDone: false,
              isFourthDone: false,
            ),
            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: FilledButtonWidget(
                height: 56,
                text: '다음',
                isEnable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
