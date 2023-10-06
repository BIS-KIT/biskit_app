// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';

import '../../common/components/tooltip_widget.dart';
import '../../common/const/colors.dart';
import '../../common/const/fonts.dart';

class SignUpEmailScreen extends ConsumerStatefulWidget {
  final SignUpModel signUpModel;
  static String get routeName => 'signUpEmail';
  const SignUpEmailScreen({
    super.key,
    required this.signUpModel,
  });

  @override
  ConsumerState<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends ConsumerState<SignUpEmailScreen> {
  String email = '';
  String? emailError;
  bool isCheckEmailLoading = false;
  bool isButtonEnable = false;
  bool isPinCodeMode = false;

  late TextEditingController pinController;
  late FocusNode pinFocusNode;
  String? pinCodeError;
  String recivePinCode = '';

  late Timer timer;
  bool isTimerView = false;
  Duration pinDuration = const Duration(minutes: 5);

  @override
  void initState() {
    logger.d(widget.signUpModel.toString());
    super.initState();
    pinController = TextEditingController();
    pinFocusNode = FocusNode();
    // if (kDebugMode) {
    //   email = 'test_user@gmail.com';
    // }
  }

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
    pinFocusNode.dispose();
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
              pinCodeError = '인증번호를 다시 보내주세요';
              recivePinCode = '';
            });
          } else {
            pinDuration = Duration(seconds: seconds);
          }
        });
      },
    );
  }

  String getTiemerText() {
    return '${pinDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${pinDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void inputCheck() {
    setState(() {
      if (email.isValidEmailFormat()) {
        isButtonEnable = true;
      } else {
        isButtonEnable = false;
      }
    });
    checkValueEmail();
  }

  checkValueEmail() {
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

  checkEmailExist() async {
    bool isExist = false;
    setState(() {
      isCheckEmailLoading = true;
    });
    isExist = await ref.read(authRepositoryProvider).checkEmail(
          email: email,
        );
    setState(() {
      isCheckEmailLoading = false;
    });

    return isExist;
  }

  onTapFirstPinCode() async {
    FocusScope.of(context).unfocus();
    context.loaderOverlay.show();
    try {
      if (checkValueEmail()) {
        if (await checkEmailExist()) {
          if (!mounted) return;
          showDefaultModal(
            context: context,
            title: '이미 가입된 계정이 있어요',
            content: '$email\n계정으로 로그인해주세요',
            function: () {
              context.goNamed(
                EmailLoginScreen.routeName,
                queryParameters: {
                  'email': email,
                },
              );
            },
          );
        } else {
          // 인증번호 요청 처리
          Map<String, String>? res =
              await ref.read(authRepositoryProvider).certificate(email: email);
          if (res != null &&
              res['result'] == 'success' &&
              (res['certification'] != null &&
                  res['certification']!.length == 6)) {
            setState(() {
              // 인증번호 받은 것으로 교체해야함
              startTimer();
              isTimerView = true;
              recivePinCode = res['certification']!;
              isPinCodeMode = true;
            });
            if (!mounted) return;
            // FocusScope.of(context).requestFocus(pinFocusNode);
          }
        }
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }

  onTapRePinCodeRecive() async {
    FocusScope.of(context).unfocus();
    pinController.text = '';

    // 받은 인증번호 초기화
    setState(() {
      pinCodeError = null;
      recivePinCode = '';
    });
    Map<String, String>? res =
        await ref.read(authRepositoryProvider).certificate(email: email);
    if (res != null &&
        res['result'] == 'success' &&
        (res['certification'] != null && res['certification']!.length == 6)) {
      setState(() {
        recivePinCode = res['certification']!;
        startTimer();
        isTimerView = true;
      });
      if (!mounted) return;
      FocusScope.of(context).requestFocus(pinFocusNode);
    }
  }

  checkPinCode() {
    String pinCode = pinController.text.trim();

    if (pinCode.length == 6) {
      if (pinCode != recivePinCode) {
        setState(() {
          pinCodeError = '인증번호가 일치하지 않아요';
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerView = false;
        });
        context.pushNamed(
          SetPasswordScreen.routeName,
          extra: widget.signUpModel.copyWith(email: email),
        );
      }
    } else {
      setState(() {
        pinCodeError = null;
      });
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
                            if (!value) {
                              // 포커스 아웃시 처리
                              checkValueEmail();
                            }
                          },
                          child: TextInputWidget(
                            title: 'emailScreen.email'.tr(),
                            hintText: 'example@email.com',
                            initialValue: email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            errorText: emailError,
                            readOnly: isCheckEmailLoading,
                            onChanged: (value) {
                              email = value;
                              inputCheck();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        !isPinCodeMode
                            ? GestureDetector(
                                onTap: isCheckEmailLoading
                                    ? null
                                    : () {
                                        onTapFirstPinCode();
                                        pinFocusNode.requestFocus();
                                      },
                                child: FilledButtonWidget(
                                  height: 52,
                                  text: '인증번호 받기',
                                  isEnable: isButtonEnable,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  onTapRePinCodeRecive();
                                  pinFocusNode.requestFocus();
                                },
                                child: const OutlinedButtonWidget(
                                  height: 52,
                                  text: '인증번호 다시 받기',
                                  isEnable: true,
                                ),
                              ),
                        if (isPinCodeMode)
                          Column(
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              TextInputWidget(
                                title: '인증번호',
                                hintText: '인증번호를 입력해주세요',
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                controller: pinController,
                                focusNode: pinFocusNode,
                                errorText: pinCodeError,
                                readOnly: recivePinCode.isEmpty,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                onChanged: (value) {
                                  checkPinCode();
                                },
                                suffixIcon: !isTimerView
                                    ? null
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTiemerText(),
                                            textAlign: TextAlign.center,
                                            style: getTsCaption12Rg(context)
                                                .copyWith(
                                              color: kColorContentError,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                if (isPinCodeMode)
                  TooltipWidget(
                    tooltipText:
                        '스팸 메일함을 확인해주세요. 메일이 없다면\nteambiskit@gmail.com으로 문의해주세요.',
                    child: Text(
                      '메일을 받지 못하셨나요?',
                      style: getTsBody14Rg(context).copyWith(
                        color: kColorContentWeakest,
                      ),
                    ),
                  ),
                SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom != 0 ? 16 : 34,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
