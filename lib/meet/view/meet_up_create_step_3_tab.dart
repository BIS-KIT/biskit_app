import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

import '../../common/components/chip_widget.dart';

class MeetUpCreateStep3Tab extends StatefulWidget {
  const MeetUpCreateStep3Tab({super.key});

  @override
  State<MeetUpCreateStep3Tab> createState() => _MeetUpCreateStep3TabState();
}

class _MeetUpCreateStep3TabState extends State<MeetUpCreateStep3Tab> {
  List<String> langList = [
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
  List<String> selectedLangList = [];
  List<String> selectedTagList = [];

  void onClickLang(String subject) {
    if (selectedLangList.where((element) => subject == element).isNotEmpty) {
      setState(() {
        selectedLangList.removeWhere((element) => subject == element);
      });
    } else {
      setState(() {
        selectedLangList.add(subject);
      });
    }
  }

  void onClickTag(String subject) {
    if (selectedTagList.where((element) => subject == element).isNotEmpty) {
      setState(() {
        selectedTagList.removeWhere((element) => subject == element);
      });
    } else {
      setState(() {
        selectedTagList.add(subject);
      });
    }
  }

  List<String> sortedLangList = [];

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
                ...langList.map(
                  (e) => ChipWidget(
                    order: selectedLangList.isNotEmpty &&
                            selectedLangList
                                .where((element) => element == e)
                                .isNotEmpty
                        ? selectedLangList.indexOf(e) + 1
                        : null,
                    text: e,
                    isSelected: selectedLangList.isNotEmpty &&
                            selectedLangList
                                .where((element) => element == e)
                                .isNotEmpty
                        ? true
                        : false,
                    onClickSelect: () {
                      onClickLang(e);
                    },
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
                    isSelected: selectedTagList.isNotEmpty &&
                            selectedTagList
                                .where((element) => element == e)
                                .isNotEmpty
                        ? true
                        : false,
                    onClickSelect: () {
                      onClickTag(e);
                    },
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
