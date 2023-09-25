import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/univ_list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter/material.dart';

class UniversityScreen extends StatefulWidget {
  static String get routeName => 'universityScreen';
  const UniversityScreen({super.key});

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  @override
  void initState() {
    super.initState();
  }

  onTapSelectedUniv() {
    showDefaultModalBottomSheet(
      context: context,
      title: '학교 선택',
      titleRightButton: true,
      contentWidget: const UnivListWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '학교를 선택해주세요',
                  style: getTsHeading24(context).copyWith(
                    color: kColorGray9,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '같은 학교의 친구들을 만날 수 있어요',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorGray7,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: onTapSelectedUniv,
                  child: const OutlinedButtonWidget(
                    isEnable: true,
                    text: '학교 선택',
                    height: 52,
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {},
                child: const FilledButtonWidget(text: '다음', isEnable: false),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
