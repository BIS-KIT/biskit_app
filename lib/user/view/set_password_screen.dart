import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/input_validate_util.dart';
import 'package:biskit_app/user/view/set_password_completed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'setPassword';
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  String password = '';
  String confirmPassword = '';
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

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '비밀번호 재설정',
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
                              if (!isValidPassword(password)) {
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
                            title: '비밀번호',
                            hintText: '비밀번호를 입력해주세요',
                            errorText: passwordError,
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: obscureText,
                            focusNode: passwordFocusNode,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: kColorGray7,
                              ),
                            ),
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
                            confirmPassword = value;
                            if (value.length == password.length) {
                              if (value != password) {
                                setState(() {
                                  confirmPasswordError = '비밀번호가 일치하지 않아요';
                                });
                              } else if (value == password) {
                                setState(() {
                                  isActiveConfirmButton = true;
                                  confirmPasswordError = null;
                                });
                              }
                            } else if (value.length > password.length) {
                              setState(() {
                                confirmPasswordError = '비밀번호가 일치하지 않아요';
                              });
                            }
                          },
                          obscureText: confirmObscureText,
                          errorText: confirmPasswordError,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                confirmObscureText = !confirmObscureText;
                              });
                            },
                            icon: Icon(
                              confirmObscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: kColorGray7,
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
                    context.pushReplacementNamed(
                        SetPasswordCompletedScreen.routeName);
                  },
                  child: FilledButtonWidget(
                    text: '완료',
                    isEnable: isActiveConfirmButton,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
