import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/text_input_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpEmailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signUpEmail';
  const SignUpEmailScreen({super.key});

  @override
  ConsumerState<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends ConsumerState<SignUpEmailScreen> {
  String email = '';
  String? emailError;
  bool isButtonEnable = false;

  void inputCheck() {
    setState(() {
      if (email.isNotEmpty) {
        isButtonEnable = true;
      } else {
        isButtonEnable = false;
      }
    });
  }

  checkEmail() {
    if (email.isEmpty) {
      setState(() {
        emailError = '이메일을 입력해주세요';
      });
      return false;
    } else if (!email.isValidEmailFormat()) {
      setState(() {
        emailError = '이메일 양식이 올바르지 않아요';
      });
      return false;
    } else {
      setState(() {
        emailError = null;
      });
      return true;
    }
  }

  onTapPinCode() {
    if (checkEmail()) {
      // TODO 이미 가입한 계정이면 로그인 화면으로 이동
      showDefaultModal(
        context: context,
        title: '이미 가입된 계정이 있어요',
        content: 'teambiskit@gmail.com\n계정으로 로그인해주세요',
        function: () {
          context.goNamed(
            EmailLoginScreen.routeName,
            queryParameters: {
              'email': email,
            },
          );
        },
      );
      // TODO 인증번호 받기 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultLayout(
        title: '',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      // 포커스 아웃시 처리
                      checkEmail();
                    }
                  },
                  child: TextInputWidget(
                    title: 'emailScreen.email'.tr(),
                    hintText: '이메일을 입력해주세요',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: emailError,
                    onChanged: (value) {
                      email = value;
                      inputCheck();
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: onTapPinCode,
                  child: FilledButtonWidget(
                    text: '인증번호 받기',
                    isEnable: isButtonEnable,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
