import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/test_screen.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void kakaoLogin() {}
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TestScreen(),
                    ));
              },
              child: const Text('Test'),
            )
          : null,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 67,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '타이틀',
                          style: getTsHeading24(context).copyWith(
                            color: kColorGray9,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '서비스 설명 텍스트',
                          style: getTsBody16Rg(context).copyWith(
                            color: kColorGray7,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: kakaoLogin,
                          child: Container(
                            width: 56,
                            height: 56,
                            padding: const EdgeInsets.all(19),
                            decoration: const BoxDecoration(
                              color: Color(0xffFEE500),
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SvgPicture.asset(
                              'assets/icons/symbol_kakao.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(EmailLoginScreen.routeName);
                },
                child: const OutlinedButtonWidget(
                  text: '이메일로 시작하기',
                  isEnable: true,
                  height: 52,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // if (kDebugMode)
              //   ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const TestScreen(),
              //           ));
              //     },
              //     child: const Text(
              //       'Test Screen',
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
