import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CurrentPasswordVerifyScreen extends ConsumerStatefulWidget {
  const CurrentPasswordVerifyScreen({super.key});

  @override
  ConsumerState<CurrentPasswordVerifyScreen> createState() =>
      _CurrentPasswordVerifyScreenState();
}

class _CurrentPasswordVerifyScreenState
    extends ConsumerState<CurrentPasswordVerifyScreen> {
  String currentPassword = '';
  bool obscureText = true;
  String? currentPasswordError;
  bool isButtonActive = true;

  confirmCurrentPassword() async {
    try {
      logger.d('message');
      bool? res = await ref.read(settingRepositoryProvider).confirmPassword(
          userId: (ref.watch(userMeProvider) as UserModel).id,
          password: currentPassword);
      if (res && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const SetPasswordScreen(pageType: PageType.reset),
          ),
        );
      } else {
        setState(() {
          currentPasswordError = '비밀번호가 올바르지 않습니다';
        });
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '비밀번호 변경',
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        TextInputWidget(
                          title: "현재 비밀번호",
                          hintText: "현재 비밀번호를 입력해주세요",
                          autofocus: true,
                          errorText: currentPasswordError,
                          onChanged: (value) {
                            if (currentPasswordError!.isNotEmpty) {
                              setState(() {
                                currentPasswordError = null;
                              });
                            }
                            setState(() {
                              currentPassword = value;
                            });
                          },
                          obscureText: obscureText,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: SvgPicture.asset(
                              obscureText
                                  ? 'assets/icons/ic_visibility_off_line_24.svg'
                                  : 'assets/icons/ic_visibility_line_24.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeakest,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: GestureDetector(
                  onTap: () {
                    confirmCurrentPassword();
                  },
                  child: MediaQuery.of(context).viewInsets.bottom != 0
                      ? FullBleedButtonWidget(
                          text: '다음',
                          isEnable: isButtonActive,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 34),
                          child: FilledButtonWidget(
                              text: '다음', isEnable: isButtonActive),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
