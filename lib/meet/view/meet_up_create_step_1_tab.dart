import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';

class MeetUpCreateStep1Tab extends StatefulWidget {
  const MeetUpCreateStep1Tab({super.key});

  @override
  State<MeetUpCreateStep1Tab> createState() => _MeetUpCreateStep1TabState();
}

class _MeetUpCreateStep1TabState extends State<MeetUpCreateStep1Tab> {
  List<String> subjectList = [
    '식사',
    '카페',
    '액티비티',
    '언어교환',
    '스터디',
    '문화·예술',
    '취미',
    '여행'
  ];

  List<String> selectedSubjectList = [];
  String customSubject = '직접입력';
  late FocusNode customSubjectFocusNode;

  @override
  void initState() {
    super.initState();
    customSubjectFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    customSubjectFocusNode.dispose();
  }

  void onClickChip(String subject) {
    if (selectedSubjectList.where((element) => subject == element).isNotEmpty) {
      setState(() {
        selectedSubjectList.removeWhere((element) => subject == element);
      });
    } else {
      setState(() {
        selectedSubjectList.add(subject);
      });
    }
  }

  void onWriteChip(String subject) {
    FocusScope.of(context).requestFocus();
    setState(() {
      customSubject = subject;
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
              '무엇을 할건가요?',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              '3개까지 선택 가능해요',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeaker,
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
                    isSelected: selectedSubjectList.isNotEmpty &&
                            selectedSubjectList
                                .where((element) => element == e)
                                .isNotEmpty
                        ? true
                        : false,
                    onClickSelect: () {
                      onClickChip(e);
                    },
                  ),
                ),
                ChipWidget(
                  text: customSubject,
                  isSelected: false,
                  onTapAdd: onWriteChip,
                  onTapDelete: null,
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
