import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/user/view/find_id_screen.dart';
import 'package:biskit_app/user/view/find_password_screen.dart';
import 'package:biskit_app/user/view/sign_up_agree_screen.dart';

import '../../common/component/outlined_button_widget.dart';
import '../../common/component/text_input_widget.dart';
import '../../common/utils/widget_util.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'emailLogin';

  final String? email;
  const EmailLoginScreen({
    super.key,
    this.email,
  });

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  bool isLoginButtonEnable = false;
  String email = '';
  String? emailError;
  String password = '';
  String? passwordError;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    logger.d('widget.email:${widget.email}');
    email = widget.email ?? '';
  }

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
                Focus(
                  onFocusChange: (value) {
                    if (!value && email.isNotEmpty) {
                      // 포커스 아웃시 처리
                      checkEmail();
                    }
                  },
                  child: TextInputWidget(
                    initialValue: widget.email,
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
                  height: 20,
                ),
                TextInputWidget(
                  title: 'emailScreen.password'.tr(),
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (value) {
                    password = value;
                    inputCheck();
                  },
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
                  child: OutlinedButtonWidget(
                    text: '로그인',
                    isEnable: isLoginButtonEnable,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // signup button
                GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed(SignUpAgreeScreen.routeName);
                  },
                  child: const FilledButtonWidget(
                    text: '회원가입',
                    isEnable: true,
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
