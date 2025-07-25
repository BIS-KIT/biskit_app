import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/find_password_screen.dart';
import 'package:biskit_app/user/view/sign_up_agree_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/components/outlined_button_widget.dart';
import '../../common/components/text_input_widget.dart';
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

  bool obscureText = true;

  UserModelBase? state;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    logger.d('widget.email:${widget.email}');
    email = widget.email ?? '';
    // if (kDebugMode) {
    //   email = 'test_user@gmail.com';
    //   password = 'xxx123';
    //   isLoginButtonEnable = true;
    // }
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

  bool checkEmail() {
    if (!email.isValidEmailFormat()) {
      setState(() {
        emailError = 'emailLoginScreen.email.error'.tr();
      });
      return false;
    } else {
      setState(() {
        emailError = null;
      });
      return true;
    }
  }

  login() async {
    FocusScope.of(context).unfocus();
    if (checkEmail()) {
      // context.loaderOverlay.show();
      UserModelBase? userModelBase =
          await ref.read(userMeProvider.notifier).login(
                email: email,
                password: password,
              );

      // logger.d(state);
      if (!mounted) return;
      // context.loaderOverlay.hide();
      if (userModelBase is UserModelError) {
        showSnackBar(
          context: context,
          text: (userModelBase).message,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(userMeProvider);
    return DefaultLayout(
      title: 'emailLoginScreen.title'.tr(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value && email.isNotEmpty) {
                      // 포커스 아웃시 처리
                      checkEmail();
                    }
                  },
                  child: TextInputWidget(
                    initialValue: email,
                    title: 'emailLoginScreen.email.title'.tr(),
                    hintText: 'emailLoginScreen.email.placeholder'.tr(),
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
                  title: 'emailLoginScreen.password.title'.tr(),
                  hintText: 'emailLoginScreen.password.placeholder'.tr(),
                  initialValue: password,
                  onChanged: (value) {
                    password = value;
                    inputCheck();
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
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       obscureText = !obscureText;
                  //     });
                  //   },
                  //   icon: Icon(
                  //     obscureText
                  //         ? Icons.visibility_off_outlined
                  //         : Icons.visibility_outlined,
                  //     color: kColorContentWeaker,
                  //   ),
                  // ),
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
                    height: 52,
                    text: 'emailLoginScreen.login'.tr(),
                    isEnable: isLoginButtonEnable,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // signup button
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context.goNamed(
                      SignUpAgreeScreen.routeName,
                      extra: SignUpModel(),
                    );
                  },
                  child: FilledButtonWidget(
                    height: 52,
                    text: 'emailLoginScreen.signUp'.tr(),
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
                    // TODO: id 찾기 나중에 추가
                    // GestureDetector(
                    //   onTap: () {
                    //     context.pushNamed(FindIdScreen.routeName);
                    //   },
                    //   child: Text(
                    //     'emailLoginScreen.findEmail'.tr(),
                    //     style: getTsBody14Rg(context).copyWith(
                    //       color: kColorContentWeaker,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 12,
                    // ),
                    // Text(
                    //   '|',
                    //   style: getTsBody14Rg(context).copyWith(
                    //     color: kColorBgElevation3,
                    //   ),
                    // ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(FindPasswordScreen.routeName);
                      },
                      child: Text(
                        'emailLoginScreen.resetPassword'.tr(),
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeaker,
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
