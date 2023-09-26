import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:biskit_app/common/utils/logger_util.dart';

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
  bool isFirsthAuthNumRequest = true;
  bool isShowAuthNumBox = false;
  late TextEditingController pinController;
  late FocusNode pinFocusNode;
  final JustTheController tooltipController = JustTheController();

  String? pinCodeError;
  String receivePinCode = '';
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

  void inputCheck() {
    setState(() {
      if (email.isNotEmpty && email.isValidEmailFormat()) {
        emailError = null;
        isPinCodeButton = true;
      } else {
        isPinCodeButton = false;
      }
    });
  }

  checkPinCode() {
    String pinCode = pinController.text.trim();

    if (pinCode.length == 6) {
      if (pinCode != receivePinCode) {
        setState(() {
          pinCodeError = '인증번호가 일치하지 않아요';
        });
      } else {
        context.pushNamed(SetPasswordScreen.routeName);
      }
    } else {
      setState(() {
        pinCodeError = null;
      });
    }
  }

  onTapPinCodeRecive() {
    pinController.text = '';

    // 받은 인증번호 초기화
    setState(() {
      pinCodeError = null;
      receivePinCode = '';
    });
    // TODO 인증번호 재발송 처리
    setState(() {
      // TODO 인증번호 받은 것으로 교체해야함

      receivePinCode = '121212';
    });
    // XXX: duration 설정한 이유: if 조건문에 따라 인증번호 위젯이 생기는데, [인증번호 받기] 버튼 클릭과 동시에 인증번호 입력 위젯에 focus를 주게되면 focus가 위젯이 렌더링 되기 전(혹은 바로 동시에)에 작동해서 focus가 제대로 안 먹힘 -> 의도적으로 위젯 렌더링 후 focus 주는 시점을 delay해서 인증번호 입력 위젯이 생기고 난 뒤에 포커스 설정
    Future.delayed(const Duration(milliseconds: 10), () {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'findPasswordScreen.title'.tr(),
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
                        height: 40,
                      ),
                      Focus(
                          onFocusChange: (value) {
                            if (!value && email.isEmpty) {
                              setState(() {
                                emailError = "이메일을 입력해주세요";
                              });
                            } else if (email.isNotEmpty &&
                                !email.isValidEmailFormat()) {
                              setState(() {
                                emailError = '이메일 양식이 올바르지 않아요';
                              });
                            } else {
                              setState(() {
                                emailError = null;
                              });
                            }
                          },
                          child: TextInputWidget(
                            title: 'emailScreen.email'.tr(),
                            hintText: '가입한 이메일을 입력해주세요',
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
                      if (isFirsthAuthNumRequest)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFirsthAuthNumRequest = false;
                              isShowAuthNumBox = true;
                            });
                            onTapPinCodeRecive();
                          },
                          child: FilledButtonWidget(
                              text: '인증번호 받기', isEnable: isPinCodeButton),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            onTapPinCodeRecive();
                          },
                          child: const OutlinedButtonWidget(
                            text: '인증번호 다시 받기',
                            isEnable: true,
                          ),
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                      if (isShowAuthNumBox)
                        TextInputWidget(
                          title: '인증번호',
                          hintText: '인증번호를 입력해주세요',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          controller: pinController,
                          focusNode: pinFocusNode,
                          errorText: pinCodeError,
                          onChanged: (value) {
                            checkPinCode();
                          },
                          suffixIcon: receivePinCode.isEmpty
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
                                    color: kColorContentError,
                                  ),
                                  colonsTextStyle:
                                      getTsCaption12Rg(context).copyWith(
                                    color: kColorContentError,
                                  ),
                                  onEnd: () {
                                    setState(() {
                                      receivePinCode = '';
                                      pinCodeError = '인증번호를 다시 보내주세요';
                                    });
                                  },
                                ),
                        )
                    ],
                  ),
                ),
              ),
              if (!isFirsthAuthNumRequest)
                JustTheTooltip(
                  controller: tooltipController,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  backgroundColor: Colors.black.withOpacity(0.7),
                  elevation: 0,
                  tailBaseWidth: 20,
                  tailLength: 6,
                  preferredDirection: AxisDirection.up,
                  content: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '스팸 메일함을 확인해주세요. 메일이 없다면\nteambiskit@gmail.com으로 문의해주세요.',
                      style: getTsBody14Sb(context).copyWith(
                        color: kColorBgDefault,
                      ),
                    ),
                  ),
                  offset: 8,
                  tailBuilder: (tip, point2, point3) {
                    logger.d(tip);
                    logger.d(point2);
                    logger.d(point3);
                    return Path()
                      ..moveTo(tip.dx - (tip.dx * 0.5), tip.dy)
                      ..lineTo(point2.dx - (point2.dx * 0.5), point2.dy)
                      ..lineTo(point3.dx - (point3.dx * 0.5), point3.dy)
                      ..close();
                  },
                  child: GestureDetector(
                    onTap: () {
                      tooltipController.showTooltip();
                    },
                    child: Text(
                      '메일을 받지 못하셨나요?',
                      style: getTsBody14Rg(context)
                          .copyWith(color: kColorContentWeakest),
                    ),
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
