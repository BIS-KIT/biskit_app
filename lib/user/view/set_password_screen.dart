// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:biskit_app/setting/view/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/common/view/name_birth_gender_screen.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/set_password_completed_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

// 비밀번호 설정 페이지로 이동하는 페이지 1. 가입 2. 찾기 3. 재설정
enum PageType { register, find, reset }

class SetPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'setPassword';

  final SignUpModel? signUpModel;
  final PageType pageType;

  final String? token;
  const SetPasswordScreen({
    super.key,
    this.signUpModel,
    this.token,
    required this.pageType,
  });

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  String password = '';
  bool obscureText = true;
  bool confirmObscureText = true;
  String? passwordError;
  String? confirmPasswordError;
  bool isActiveConfirmButton = false;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode(); // FocusNode 초기화
    confirmPasswordFocusNode = FocusNode(); // FocusNode 초기화
    passwordFocusNode.requestFocus(); // 비밀번호 입력 필드에 포커스를 설정
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  findAndResetPassword() async {
    context.loaderOverlay.show();
    try {
      bool? res = await ref
          .read(authRepositoryProvider)
          .changePassword(newPassword: password);
      if (res) {
        context.pushReplacementNamed(SetPasswordCompletedScreen.routeName);
      } else {
        setState(() {
          confirmPasswordError = '비밀번호 재설정에 실패했습니다.';
        });
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }

  changePassword() async {
    context.loaderOverlay.show();
    try {
      bool? res = await ref
          .read(authRepositoryProvider)
          .changePassword(newPassword: password);
      if (res && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SettingScreen(),
          ),
        );
      } else {
        setState(() {
          confirmPasswordError = '비밀번호 재설정에 실패했습니다.';
        });
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: widget.pageType == PageType.register
            ? ''
            : widget.pageType == PageType.find
                ? '비밀번호 재설정'
                : '비밀번호 변경',
        child: SafeArea(
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
                        Focus(
                          onFocusChange: (value) {
                            if (!value && password.isNotEmpty) {
                              if (!password.isValidPassword()) {
                                setState(() {
                                  passwordError = '8자 이상으로 입력해주세요';
                                });
                              } else {
                                setState(() {
                                  passwordError = null;
                                });
                              }
                            }
                          },
                          child: TextInputWidget(
                            title: widget.pageType == PageType.register
                                ? '비밀번호'
                                : '새 비밀번호',
                            hintText: widget.pageType == PageType.register
                                ? '비밀번호를 입력해주세요'
                                : '새 비밀번호를 입력해주세요',
                            errorText: passwordError,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: obscureText,
                            focusNode: passwordFocusNode,
                            textInputAction: TextInputAction.next,
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
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (password.isEmpty)
                          Text(
                            '8자 이상으로 입력해주세요',
                            style: getTsCaption12Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextInputWidget(
                          title: '비밀번호 확인',
                          hintText: '다시 한번 입력해주세요',
                          focusNode: confirmPasswordFocusNode,
                          onChanged: (value) {
                            if (value != password) {
                              setState(() {
                                isActiveConfirmButton = false;
                                confirmPasswordError = '비밀번호가 일치하지 않아요';
                              });
                            } else if (value == password) {
                              setState(() {
                                isActiveConfirmButton = true;
                                confirmPasswordError = null;
                              });
                            }
                          },
                          obscureText: confirmObscureText,
                          errorText: confirmPasswordError,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                confirmObscureText = !confirmObscureText;
                              });
                            },
                            child: SvgPicture.asset(
                              confirmObscureText
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
                        const SizedBox(
                          height: 8,
                        ),
                        if (isActiveConfirmButton)
                          Text(
                            '비밀번호가 일치해요',
                            style: getTsCaption12Rg(context).copyWith(
                              color: kColorContentSeccess,
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
                    if (!isActiveConfirmButton) return;
                    // 회원가입
                    if (widget.pageType == PageType.register) {
                      context.pushNamed(
                        NameBirthGenderScreen.routeName,
                        extra: widget.signUpModel!.copyWith(
                          password: password,
                        ),
                      );
                    }
                    // 비밀번호 찾기
                    else if (widget.pageType == PageType.find) {
                      findAndResetPassword();
                    }
                    // 비밀번호 재설정
                    else if (widget.pageType == PageType.reset) {
                      changePassword();
                    }
                  },
                  child: MediaQuery.of(context).viewInsets.bottom != 0
                      ? FullBleedButtonWidget(
                          text: widget.pageType == PageType.register
                              ? '다음'
                              : '완료',
                          isEnable: isActiveConfirmButton,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 34),
                          child: FilledButtonWidget(
                              text: widget.pageType == PageType.register
                                  ? '다음'
                                  : '완료',
                              isEnable: isActiveConfirmButton),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
