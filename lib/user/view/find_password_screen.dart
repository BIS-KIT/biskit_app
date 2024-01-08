import 'dart:async';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/components/tooltip_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'findPassword';
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  bool isPinCodeButton = false;
  String email = '';
  String? emailError;
  bool isButtonEnable = false;
  bool isPinCodeMode = false;

  late TextEditingController pinController;
  late FocusNode pinFocusNode;

  String? pinCodeError;

  late Timer timer;
  bool isTimerView = false;
  Duration pinDuration = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    pinFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
    pinFocusNode.dispose();
  }

  String getTiemerText() {
    return '${pinDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${pinDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  checkEmailExist() async {
    bool isExist = false;
    isExist = await ref.read(authRepositoryProvider).checkEmail(
          email: email,
        );
    return isExist;
  }

  void inputCheck() async {
    if (email.isNotEmpty && email.isValidEmailFormat()) {
      if (await checkEmailExist()) {
        setState(() {
          emailError = null;
          isButtonEnable = true;
        });
      } else {
        setState(() {
          emailError = 'resetPasswordScreen1.email.loginError'.tr();
          isButtonEnable = false;
        });
      }
    } else {
      setState(() {
        isButtonEnable = false;
        emailError = null;
      });
    }
  }

  checkPinCode() async {
    String pinCode = pinController.text.trim();
    if (pinCode.length == 6) {
      context.loaderOverlay.show();
      try {
        Map<String, String>? res = await ref
            .read(authRepositoryProvider)
            .changePasswordCertificateCheck(email: email, pinCode: pinCode);
        if (res != null) {
          if (res['result'] == 'success' && res['token'] != "") {
            timer.cancel();
            setState(() {
              isTimerView = false;
            });
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SetPasswordScreen(
                      pageType: PageType.find,
                      token: res['token'],
                    )));
          } else {
            setState(() {
              pinCodeError = 'resetPasswordScreen2.vCode.wrongError'.tr();
            });
          }
        }
      } finally {
        context.loaderOverlay.hide();
      }
    } else {
      setState(() {
        pinCodeError = null;
      });
    }
  }

  void startTimer() {
    pinDuration = const Duration(minutes: 5);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          final seconds = pinDuration.inSeconds - 1;
          if (seconds < 0) {
            timer.cancel();

            // 시간 오버인 경우
            setState(() {
              pinCodeError = 'resetPasswordScreen2.vCode.timeoutError'.tr();
              // receivePinCode = '';
            });
          } else {
            pinDuration = Duration(seconds: seconds);
          }
        });
      },
    );
  }

  onTapPinCodeRecive({bool resend = false}) async {
    FocusScope.of(context).unfocus();
    context.loaderOverlay.show();

    if (resend) {
      setState(() {
        timer.cancel();
        pinCodeError = null;
        pinController.text = '';
      });
    }
    try {
      Map<String, String>? res = await ref
          .read(authRepositoryProvider)
          .changePasswordCertificate(email: email);
      if (res != null &&
          res['result'] == 'success' &&
          (res['certification'] != null && res['certification']!.length == 6)) {
        startTimer();
        setState(() {
          isTimerView = true;
          isPinCodeMode = true;
        });
        if (!mounted) return;
      }
    } finally {
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
    }

    // XXX: duration 설정한 이유: if 조건문에 따라 인증번호 위젯이 생기는데, [인증번호 받기] 버튼 클릭과 동시에 인증번호 입력 위젯에 focus를 주게되면 focus가 위젯이 렌더링 되기 전(혹은 바로 동시에)에 작동해서 focus가 제대로 안 먹힘 -> 의도적으로 위젯 렌더링 후 focus 주는 시점을 delay해서 인증번호 입력 위젯이 생기고 난 뒤에 포커스 설정
    Future.delayed(const Duration(milliseconds: 10), () {
      // FocusScope.of(context).requestFocus(pinFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'resetPasswordScreen1.title'.tr(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Focus(
                          onFocusChange: (value) {
                            if (!value && email.isEmpty) {
                              setState(() {
                                emailError =
                                    "resetPasswordScreen1.email.inputError"
                                        .tr();
                              });
                            } else if (email.isNotEmpty &&
                                !email.isValidEmailFormat()) {
                              setState(() {
                                emailError =
                                    'resetPasswordScreen1.email.formatError'
                                        .tr();
                              });
                            } else {
                              setState(() {
                                emailError = null;
                              });
                            }
                          },
                          child: TextInputWidget(
                            title: 'resetPasswordScreen1.email.title'.tr(),
                            hintText:
                                'resetPasswordScreen1.email.placeholder'.tr(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            errorText: emailError,
                            onChanged: (value) {
                              email = value;
                              inputCheck();
                            },
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      !isPinCodeMode
                          ? GestureDetector(
                              onTap: () {
                                onTapPinCodeRecive();
                                pinFocusNode.requestFocus();
                              },
                              child: FilledButtonWidget(
                                height: 52,
                                text: 'resetPasswordScreen1.getCode'.tr(),
                                isEnable: isButtonEnable,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                onTapPinCodeRecive(resend: true);
                                pinFocusNode.requestFocus();
                              },
                              child: OutlinedButtonWidget(
                                height: 52,
                                text: 'resetPasswordScreen2.resendVCode'.tr(),
                                isEnable: true,
                              ),
                            ),
                      const SizedBox(
                        height: 24,
                      ),
                      if (isPinCodeMode)
                        TextInputWidget(
                          title: 'resetPasswordScreen2.vCode.title'.tr(),
                          hintText:
                              'resetPasswordScreen2.vCode.placeholder'.tr(),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          controller: pinController,
                          focusNode: pinFocusNode,
                          errorText: pinCodeError,
                          onChanged: (value) {
                            checkPinCode();
                          },
                          suffixIcon: !isTimerView
                              ? null
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTiemerText(),
                                      textAlign: TextAlign.center,
                                      style: getTsCaption12Rg(context).copyWith(
                                        color: kColorContentError,
                                      ),
                                    ),
                                  ],
                                ),
                        )
                    ],
                  ),
                ),
              ),
              if (isPinCodeMode)
                TooltipWidget(
                  preferredDirection: AxisDirection.up,
                  tooltipText: 'resetPasswordScreen2.noVCode.content'.tr(),
                  child: Text(
                    'resetPasswordScreen2.noVCode.title'.tr(),
                    style: getTsBody14Rg(context)
                        .copyWith(color: kColorContentWeakest),
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom != 0 ? 16 : 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
