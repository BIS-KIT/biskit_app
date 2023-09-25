// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/sign_up_completed_screen.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:go_router/go_router.dart';

class UniversityCompletedScreen extends StatelessWidget {
  static String get routeName => 'universityCompleted';

  final SignUpModel signUpModel;
  final String? selectedStudentStatus;
  final String? selectedUniv;
  final String? selectedGraduateStatus;

  const UniversityCompletedScreen({
    Key? key,
    required this.signUpModel,
    this.selectedStudentStatus,
    this.selectedUniv,
    this.selectedGraduateStatus,
  }) : super(key: key);

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
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '학교를 선택해주세요',
                  style: getTsHeading24(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '같은 학교의 친구들을 만날 수 있어요',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeaker,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: ShapeDecoration(
                    color: kColorBgElevation1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '학교',
                              style: getTsBody16Sb(context)
                                  .copyWith(color: kColorContentWeak),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  selectedUniv!,
                                  style: getTsBody16Rg(context)
                                      .copyWith(color: kColorContentWeak),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: kColorBgElevation3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '소속',
                              style: getTsBody16Sb(context)
                                  .copyWith(color: kColorContentWeak),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  selectedStudentStatus!,
                                  style: getTsBody16Rg(context)
                                      .copyWith(color: kColorContentWeak),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: kColorBgElevation3,
                          )),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '학적상태',
                              style: getTsBody16Sb(context)
                                  .copyWith(color: kColorContentWeak),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  selectedGraduateStatus!,
                                  style: getTsBody16Rg(context)
                                      .copyWith(color: kColorContentWeak),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    context.goNamed(
                      UniversityScreen.routeName,
                      extra: signUpModel,
                    );
                  },
                  child: const OutlinedButtonWidget(
                    isEnable: true,
                    text: '다시 선택하기',
                    height: 52,
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpCompletedScreen(),
                      ));
                },
                child: const FilledButtonWidget(text: '가입하기', isEnable: true),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
