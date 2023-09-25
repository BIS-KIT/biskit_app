import 'package:biskit_app/common/components/checkbox_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/view/sign_up_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignUpAgreeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signUpAgree';
  const SignUpAgreeScreen({super.key});

  @override
  ConsumerState<SignUpAgreeScreen> createState() => _SignUpAgreeScreenState();
}

class _SignUpAgreeScreenState extends ConsumerState<SignUpAgreeScreen> {
  bool isAll = false;
  bool isAgree1 = false;
  bool isAgree2 = false;
  bool isAgree3 = false;
  bool isAgree4 = false;

  onTapAll() {
    setState(() {
      isAll = !isAll;
      isAgree1 = isAll;
      isAgree2 = isAll;
      isAgree3 = isAll;
      isAgree4 = isAll;
    });
  }

  checkAll() {
    setState(() {
      isAll = isAgree1 && isAgree2 && isAgree3 && isAgree4;
    });
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
              const SizedBox(
                height: 24,
              ),
              Text(
                '회원가입 전\n이용약관 동의가 필요해요',
                style: getTsHeading24(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 64,
              ),

              // 약관
              GestureDetector(
                onTap: onTapAll,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxWidget(
                        value: isAll,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '전체 동의하기',
                      style: getTsHeading18(context).copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                thickness: 1,
                color: kColorBgElevation3,
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAgree1 = !isAgree1;
                  });
                  checkAll();
                },
                child: _buildRow(
                  context: context,
                  text: '[필수] 서비스 이용약관',
                  value: isAgree1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAgree2 = !isAgree2;
                  });
                  checkAll();
                },
                child: _buildRow(
                  context: context,
                  text: '[필수] 개인정보 처리방침',
                  value: isAgree2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAgree3 = !isAgree3;
                  });
                  checkAll();
                },
                child: _buildRow(
                  context: context,
                  text: '[필수] 위치기반 서비스 이용약관',
                  value: isAgree3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAgree4 = !isAgree4;
                  });
                  checkAll();
                },
                child: _buildRow(
                  context: context,
                  text: '[선택] 마케팅 정보 활용',
                  value: isAgree4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.pushNamed(SignUpEmailScreen.routeName);
                },
                child: FilledButtonWidget(
                  text: '다음',
                  isEnable: isAgree1 && isAgree2 && isAgree3,
                ),
              ),
              const SizedBox(
                height: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRow({
    required BuildContext context,
    required String text,
    required bool value,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 4,
          ),
          child: SvgPicture.asset(
            'assets/icons/check.svg',
            width: 16,
            height: 12,
            colorFilter: ColorFilter.mode(
              value ? kColorBorderPrimaryStrong : kColorContentDisabled,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          child: Text(
            text,
            style: getTsBody16Rg(context).copyWith(
              color: kColorContentWeaker,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO 내용 상세보기
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/icons/ic_chevron_right_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
