import 'package:biskit_app/common/components/custom_text_form_field.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpCreateStep4Tab extends StatelessWidget {
  const MeetUpCreateStep4Tab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 32,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(
                0xffFEF3EB,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kColorBgInverseWeak,
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_pencil_fill_24.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제목을 입력해주세요',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              onChanged: (value) {},
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButtonWidget(
              text: '모임설명 추가',
              leftIconPath: 'assets/icons/ic_plus_line_24.svg',
              isEnable: true,
            ),
          ],
        ),
      ],
    );
  }
}
