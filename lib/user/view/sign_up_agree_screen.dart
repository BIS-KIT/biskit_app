// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/check_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/components/select_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/sign_up_email_screen.dart';

import '../../common/view/name_birth_gender_screen.dart';

class SignUpAgreeScreen extends ConsumerStatefulWidget {
  final SignUpModel signUpModel;
  const SignUpAgreeScreen({
    super.key,
    required this.signUpModel,
  });
  static String get routeName => 'signUpAgree';

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
        bottom: false,
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
              ListWidget(
                height: 40,
                borderColor: kColorBgDefault,
                onTap: onTapAll,
                touchWidget: CheckCircleWidget(
                  value: isAll,
                ),
                centerWidget: Text(
                  '전체 동의하기',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),
              const Divider(
                thickness: 1,
                height: 1,
                color: kColorBgElevation3,
              ),
              const SizedBox(
                height: 16,
              ),
              ListWidget(
                height: 40,
                borderColor: kColorBgDefault,
                touchWidget: CheckWidget(
                  value: isAgree1,
                ),
                onTap: () {
                  setState(() {
                    isAgree1 = !isAgree1;
                  });
                  checkAll();
                },
                centerWidget: Text(
                  '[필수] 서비스 이용약관',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                rightWidget: SelectWidget(
                  text: '',
                  usageType: 'body',
                  iconPath: 'assets/icons/ic_chevron_right_line_24.svg',
                  onTap: () {},
                ),
              ),
              ListWidget(
                height: 40,
                borderColor: kColorBgDefault,
                touchWidget: CheckWidget(
                  value: isAgree2,
                ),
                onTap: () {
                  setState(() {
                    isAgree2 = !isAgree2;
                  });
                  checkAll();
                },
                centerWidget: Text(
                  '[필수] 개인정보 처리방침',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                rightWidget: SelectWidget(
                  text: '',
                  usageType: 'body',
                  iconPath: 'assets/icons/ic_chevron_right_line_24.svg',
                  onTap: () {},
                ),
              ),

              ListWidget(
                height: 40,
                borderColor: kColorBgDefault,
                touchWidget: CheckWidget(
                  value: isAgree3,
                ),
                onTap: () {
                  setState(() {
                    isAgree3 = !isAgree3;
                  });
                  checkAll();
                },
                centerWidget: Text(
                  '[필수] 위치기반 서비스 이용약관',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                rightWidget: SelectWidget(
                  text: '',
                  usageType: 'body',
                  iconPath: 'assets/icons/ic_chevron_right_line_24.svg',
                  onTap: () {},
                ),
              ),
              ListWidget(
                height: 40,
                borderColor: kColorBgDefault,
                touchWidget: CheckWidget(
                  value: isAgree4,
                ),
                onTap: () {
                  setState(() {
                    isAgree4 = !isAgree4;
                  });
                  checkAll();
                },
                centerWidget: Text(
                  '[선택] 마케팅 정보 활용',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                rightWidget: SelectWidget(
                  text: '',
                  usageType: 'body',
                  iconPath: 'assets/icons/ic_chevron_right_line_24.svg',
                  onTap: () {},
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (isAgree1 && isAgree2 && isAgree3) {
                    if (widget.signUpModel.sns_type != null) {
                      context.pushNamed(
                        NameBirthGenderScreen.routeName,
                        extra: widget.signUpModel.copyWith(
                          terms_mandatory: isAgree1,
                          terms_optional: isAgree2,
                          terms_push: isAgree3,
                        ),
                      );
                    } else {
                      context.pushNamed(
                        SignUpEmailScreen.routeName,
                        extra: widget.signUpModel.copyWith(
                          terms_mandatory: isAgree1,
                          terms_optional: isAgree2,
                          terms_push: isAgree3,
                        ),
                      );
                    }
                  }
                },
                child: FilledButtonWidget(
                  text: '다음',
                  height: 56,
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
}
