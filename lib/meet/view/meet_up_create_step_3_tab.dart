import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

import '../../common/components/chip_widget.dart';

class MeetUpCreateStep3Tab extends StatelessWidget {
  const MeetUpCreateStep3Tab({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> lanList = [
      '한국어',
      '영어',
      '스페인어',
      '일본어',
      '중국어',
      '깐따삐아어',
      'MZ어',
    ];
    List<String> tagList = [
      '영어 못해는 댑슈??',
      '혼자와도 괜찮은데요?',
      '늦참이라도 일단 와바유',
      '뒷풀이 없어유',
      '더치페이는 알아서',
      '카카오페이 안씁니다',
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
              '모임에서 사용하고 싶은 언어를\n순서대로 선택해주세요',
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
                ...lanList.map(
                  (e) => ChipWidget(
                    text: e,
                    isSelected: false,
                    onClickSelect: () {},
                  ),
                ),
              ],
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
              '태그로 모임을 소개해보세요',
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
                ...tagList.map(
                  (e) => ChipWidget(
                    text: e,
                    isSelected: false,
                    onClickSelect: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
