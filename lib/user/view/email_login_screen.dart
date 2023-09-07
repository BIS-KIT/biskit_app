import 'package:biskit_app/common/component/custom_text_form_field.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/user/view/find_id_screen.dart';
import 'package:biskit_app/user/view/find_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/utils/widget_util.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'emailLogin';
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  bool isLoginButtonEnable = false;
  String email = '';
  String? emailError;
  String password = '';
  String? passwordError;

  void inputCheck() {
    setState(() {
      if (email.isNotEmpty && password.isNotEmpty) {
        isLoginButtonEnable = true;
      } else {
        isLoginButtonEnable = false;
      }
    });
  }

  checkEmail() {
    if (!email.isValidEmailFormat()) {
      setState(() {
        emailError = '이메일 형식을 확인해주세요';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  login() {
    checkEmail();
    showSnackBar(
      context: context,
      text: '이메일 또는 비밀번호가 일치하지 않아요',
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'emailScreen.title'.tr(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'emailScreen.email'.tr(),
                      style: getTsBody14Sb(context).copyWith(
                        color: kColorGray8,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Focus(
                      onFocusChange: (value) {
                        if (!value && email.isNotEmpty) {
                          // 포커스 아웃시 처리
                          checkEmail();
                        }
                      },
                      child: CustomTextFormField(
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'emailScreen.password'.tr(),
                      style: getTsBody14Sb(context).copyWith(
                        color: kColorGray8,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      hintText: '비밀번호를 입력해주세요',
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      errorText: passwordError,
                      onChanged: (value) {
                        password = value;
                        inputCheck();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 44,
                ),

                // login button
                GestureDetector(
                  onTap: isLoginButtonEnable
                      ? () {
                          login();
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: kColorGray4,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '로그인',
                      style: getTsBody16Sb(context).copyWith(
                        color: isLoginButtonEnable ? kColorGray8 : kColorGray4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // signup button
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: kColorYellow3,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '회원가입',
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorGray9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                //
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(FindIdScreen.routeName);
                      },
                      child: Text(
                        '아이디 찾기',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorGray7,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      '|',
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorGray3,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(FindPasswordScreen.routeName);
                      },
                      child: Text(
                        '비밀번호 재설정',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorGray7,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
