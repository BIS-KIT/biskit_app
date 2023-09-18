import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpCompletedScreen extends StatelessWidget {
  const SignUpCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 80,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/welcome_illust 1.svg',
                    width: 141,
                    height: 148,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        '가입을 축하드려요!',
                        style: getTsHeading24(context).copyWith(
                          color: kColorGray9,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '서로가 편하고 즐거운 모임을 위해\n프로필 작성이 필요해요',
                        textAlign: TextAlign.center,
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorGray7,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 34,
                    ),
                    child: FilledButtonWidget(
                      text: '프로필 완성하기',
                      isEnable: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
