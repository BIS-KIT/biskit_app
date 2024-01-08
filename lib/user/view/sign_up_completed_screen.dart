import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/profile/view/profile_nickname_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignUpCompletedScreen extends StatelessWidget {
  static String get routeName => 'signUpCompleted';
  const SignUpCompletedScreen({super.key});

  onTap(BuildContext context) {
    context.pushNamed(ProfileNicknameScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        bottom: false,
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
                  ClipOval(
                    child: SvgPicture.asset(
                      'assets/images/biskit_welcome.svg',
                      width: 192,
                      height: 192,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    children: [
                      Text(
                        'signUpCompleteScreen.title'.tr(),
                        style: getTsHeading24(context).copyWith(
                          color: kColorContentDefault,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'signUpCompleteScreen.subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 34,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        onTap(context);
                      },
                      child: FilledButtonWidget(
                        text: 'signUpCompleteScreen.create'.tr(),
                        isEnable: true,
                        fontSize: FontSize.l,
                      ),
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
