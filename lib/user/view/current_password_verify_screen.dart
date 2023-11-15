import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrentPasswordVerifyScreen extends StatefulWidget {
  const CurrentPasswordVerifyScreen({super.key});

  @override
  State<CurrentPasswordVerifyScreen> createState() =>
      _CurrentPasswordVerifyScreenState();
}

class _CurrentPasswordVerifyScreenState
    extends State<CurrentPasswordVerifyScreen> {
  String currentPassword = '';
  bool obscureText = true;
  String? currentPasswordError;
  // TODO: api 연결 후 상태값 변경
  bool isButtonActive = true;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '비밀번호 변경',
        child: SafeArea(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                        TextInputWidget(
                          title: "현재 비밀번호",
                          hintText: "현재 비밀번호를 입력해주세요",
                          errorText: currentPasswordError,
                          onChanged: (value) {
                            setState(() {
                              currentPassword = value;
                              // if(currentPassword !== 실제 비밀번호) {
                              //   currentPasswordError = '비밀번호가 올바르지 않습니다';
                              // }
                            });
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SetPasswordScreen(pageType: PageType.reset),
                      ),
                    );
                  },
                  child: MediaQuery.of(context).viewInsets.bottom != 0
                      ? FullBleedButtonWidget(
                          text: '다음',
                          isEnable: isButtonActive,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 34),
                          child: FilledButtonWidget(
                              text: '다음', isEnable: isButtonActive),
                        ),
                ),
              ),
            ],
          ),
        )));
  }
}
