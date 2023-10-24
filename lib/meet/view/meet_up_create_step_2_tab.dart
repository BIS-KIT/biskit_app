import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpCreateStep2Tab extends StatelessWidget {
  const MeetUpCreateStep2Tab({super.key});

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
            const OutlinedButtonWidget(
              text: '10/21 (목) 오후 6:00',
              height: 52,
              isEnable: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorBgElevation2,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_minus_line_24.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kColorContentDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Text(
                  '3명',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Container(
                  width: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorBgElevation2,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_plus_line_24.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kColorContentDefault,
                      BlendMode.srcIn,
                    ),
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
