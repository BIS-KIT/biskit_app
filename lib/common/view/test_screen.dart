import 'package:biskit_app/common/component/checkbox_widget.dart';
import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class TestScreen extends StatefulWidget {
  static String get routeName => 'test';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  opTapkakaoLogin() async {
    logger.d(await KakaoSdk.origin);
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        logger.e(e);
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        kakao.User user = await kakao.UserApi.instance.me();
        logger.d('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');
      } catch (e) {
        logger.e(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Test Screen',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr('hello')),
            ElevatedButton(
              onPressed: () async {
                await context.setLocale(const Locale('ko', 'KR'));
                logger.d(tr('hello'));
              },
              child: const Text(
                'ko',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.setLocale(const Locale('en', 'US'));
                logger.d(tr('hello'));
              },
              child: const Text(
                'en',
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                opTapkakaoLogin();
              },
              child: const Text(
                '카카오로그인',
              ),
            ),
            const Divider(),
            const Text(
              '사진첩 테스트',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhotoManagerScreen(
                        isCamera: true,
                      ),
                    ));
              },
              child: const Text(
                '갤러리',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FilledButtonWidget(
                text: '회원가입',
                isEnable: true,
                leftIconPath: 'assets/icons/ic_arrow_back_ios_line_24.svg',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButtonWidget(
                text: '회원가입',
                isEnable: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CheckboxWidget(
              value: true,
            ),
          ],
        ),
      ),
    );
  }
}
