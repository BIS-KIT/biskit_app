import 'package:biskit_app/common/components/filled_button_widget.dart';
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
                      padding: const EdgeInsets.all(16),
                      width: 88,
                      height: 88,
                      decoration: ShapeDecoration(
                        color: kColorBgElevation2,
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
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Stack(children: [
                              // TODO: icon 너비, 색상 안 맞아서 수정해야 함
                              SvgPicture.asset(
                                'assets/icons/check.svg',
                                width: 40,
                                height: 40,
                                colorFilter: const ColorFilter.mode(
                                  kColorContentWeak,
                                  BlendMode.srcIn,
                                ),
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
                        color: kColorContentDefault,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '새로운 비밀번호로 로그인해주세요',
                      style: getTsBody16Rg(context).copyWith(
                        color: kColorContentWeaker,
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
