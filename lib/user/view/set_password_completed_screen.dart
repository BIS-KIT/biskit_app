import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetPasswordCompletedScreen extends ConsumerStatefulWidget {
  static String get routeName => 'setPasswordCompleted';
  const SetPasswordCompletedScreen({super.key});

  @override
  ConsumerState<SetPasswordCompletedScreen> createState() =>
      _SetPasswordCompletedScreenState();
}

class _SetPasswordCompletedScreenState
    extends ConsumerState<SetPasswordCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: kColorGray2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(44),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Stack(children: [
                              SvgPicture.asset(
                                'assets/icons/ic_check_line_24.svg',
                                colorFilter: const ColorFilter.mode(
                                  kColorGray9,
                                  BlendMode.srcIn,
                                ),
                                width: 56,
                                height: 56,
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      '비밀번호가 변경되었어요',
                      style: getTsHeading24(context).copyWith(
                        color: kColorGray9,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '새로운 비밀번호로 로그인해주세요',
                      style: getTsBody16Rg(context).copyWith(
                        color: kColorGray7,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {},
              child: const FilledButtonWidget(text: '로그인', isEnable: true),
            ),
            const SizedBox(
              height: 34,
            )
          ],
        ),
      ),
    );
  }
}
