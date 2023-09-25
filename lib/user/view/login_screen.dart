import 'dart:io';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/test2_screen.dart';
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
          ? Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(
                      Alignment.bottomRight.x, Alignment.bottomRight.y - 0.2),
                  child: FloatingActionButton(
                    heroTag: 'test1',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestScreen(),
                          ));
                    },
                    child: const Text(
                      'Test1',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: 'test2',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Test2Screen(),
                          ));
                    },
                    child: const Text(
                      'Test2',
                    ),
                  ),
                ),
              ],
            )
          // FloatingActionButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const TestScreen(),
          //           ));
          //     },
          //     child: const Text('Test'),
          //   )
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
                            color: kColorContentDefault,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '서비스 설명 텍스트',
                          style: getTsBody16Rg(context).copyWith(
                            color: kColorContentWeaker,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: _buildGoogle(context),
              ),
              GestureDetector(
                onTap: kakaoLogin,
                child: _buildKakao(context),
              ),
              if (Platform.isIOS)
                GestureDetector(
                  onTap: () {},
                  child: _buildApple(context),
                ),
              GestureDetector(
                onTap: () {
                  context.goNamed(EmailLoginScreen.routeName);
                },
                child: _buildEmail(context),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApple(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(
            // vertical: 14,
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                  left: 2,
                  bottom: 3,
                  right: 3,
                ),
                child: SvgPicture.asset(
                  'assets/icons/symbol_apple.svg',
                  width: 19,
                  height: 19,
                ),
              ),
              Expanded(
                child: Text(
                  'Apple로 로그인',
                  textAlign: TextAlign.center,
                  style: getTsBody16Sb(context).copyWith(
                    color: kColorBgDefault,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Container _buildEmail(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(
        // vertical: 14,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: kColorBgElevation3,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_mail_line_24.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              kColorContentWeak,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: Text(
              '이메일로 로그인',
              textAlign: TextAlign.center,
              style: getTsBody16Sb(context).copyWith(
                color: kColorContentWeak,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKakao(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(
            // vertical: 14,
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffFEE500),
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 3.5,
                ),
                child: SvgPicture.asset(
                  'assets/icons/symbol_kakao.svg',
                  width: 18,
                  height: 17,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '카카오로 로그인',
                  textAlign: TextAlign.center,
                  style: getTsBody16Sb(context).copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildGoogle(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(
            // vertical: 14,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: kColorBorderStrong,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 3,
                ),
                child: SvgPicture.asset(
                  'assets/icons/symbol_google.svg',
                  width: 18,
                  height: 18,
                ),
              ),
              Expanded(
                child: Text(
                  'Google로 로그인',
                  textAlign: TextAlign.center,
                  style: getTsBody16Sb(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
