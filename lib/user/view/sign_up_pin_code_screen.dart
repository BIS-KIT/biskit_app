import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/component/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class SignUpPinCodeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signUpPinCode';

  final String email;
  const SignUpPinCodeScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<SignUpPinCodeScreen> createState() => _SignUpPinCodeScreen();
}

class _SignUpPinCodeScreen extends ConsumerState<SignUpPinCodeScreen> {
  late TextEditingController pinController;
  late FocusNode pinFocusNode;
  String? pinCodeError;
  String recivePinCode = '';

  bool isPinCodeFirst = true;
  String reciveButtonText = '인증번호 받기';

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

  onTapPinCodeRecive() {
    pinController.text = '';

    if (isPinCodeFirst) {
      // TODO 인증번호 요청 처리
      setState(() {
        // TODO 인증번호 받은 것으로 교체해야함
        recivePinCode = '111111';
      });
      setState(() {
        reciveButtonText = '인증번호 다시받기';
        isPinCodeFirst = false;
      });
    } else {
      // 받은 인증번호 초기화
      setState(() {
        pinCodeError = null;
        recivePinCode = '';
      });
      // TODO 인증번호 재발송 처리
      setState(() {
        // TODO 인증번호 받은 것으로 교체해야함
        recivePinCode = '222222';
      });
    }

    FocusScope.of(context).requestFocus(pinFocusNode);
  }

  checkPinCode() {
    String pinCode = pinController.text.trim();

    if (pinCode.length == 6) {
      if (pinCode != recivePinCode) {
        setState(() {
          pinCodeError = '인증번호가 일치하지 않아요';
        });
      } else {
        // TODO 다음페이지로 이동
      }
    } else {
      setState(() {
        pinCodeError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      TextInputWidget(
                        title: '이메일',
                        initialValue: widget.email,
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          onTapPinCodeRecive();
                        },
                        child: OutlinedButtonWidget(
                          text: reciveButtonText,
                          isEnable: true,
                        ),
                      ),
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
                        onChanged: (value) {
                          checkPinCode();
                        },
                        suffixIcon: recivePinCode.isEmpty
                            ? null
                            : TimerCountdown(
                                endTime: DateTime.now().add(
                                  const Duration(
                                    minutes: 5,
                                    // seconds: 4,
                                  ),
                                ),
                                enableDescriptions: false,
                                spacerWidth: 0,
                                format: CountDownTimerFormat.minutesSeconds,
                                timeTextStyle:
                                    getTsCaption12Rg(context).copyWith(
                                  color: kColorDangerDark,
                                ),
                                onEnd: () {
                                  setState(() {
                                    recivePinCode = '';
                                    pinCodeError = '인증번호를 다시 보내주세요';
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '메일을 받지 못하셨나요?',
                style: getTsBody16Rg(context).copyWith(
                  color: kColorGray6,
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
