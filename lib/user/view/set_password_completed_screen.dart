import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SetPasswordCompletedScreen extends ConsumerStatefulWidget {
  static String get routeName => 'setPasswordCompleted';
  const SetPasswordCompletedScreen({super.key});

  @override
  ConsumerState<SetPasswordCompletedScreen> createState() =>
      _SetPasswordCompletedScreenState();
}

class _SetPasswordCompletedScreenState
    extends ConsumerState<SetPasswordCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed(EmailLoginScreen.routeName);
                  },
                  child: FilledButtonWidget(
                    text: 'resetPasswordCompleteScreen.login'.tr(),
                    isEnable: true,
                    height: 56,
                  ),
                ),
                const SizedBox(
                  height: 34,
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: kColorBgElevation2,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_check_line_24.svg',
                  width: 56,
                  height: 56,
                  colorFilter: const ColorFilter.mode(
                    kColorContentWeak,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'resetPasswordCompleteScreen.pwChangedTitle'.tr(),
                style: getTsHeading24(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'pwChangedTitle.pwChangedText'.tr(),
                style: getTsBody16Rg(context).copyWith(
                  color: kColorContentWeaker,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
