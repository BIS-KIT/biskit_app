import 'package:biskit_app/common/component/checkbox_widget.dart';
import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/full_bleed_button_widget.dart';
import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/component/search_bar_widget.dart';
import 'package:biskit_app/common/component/select_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/common/view/single_national_flag_screen%20copy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TestScreen extends StatefulWidget {
  static String get routeName => 'test';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  SelectWidgetValueType selectWidgetValueType = SelectWidgetValueType.none;
  opTapkakaoLogin() async {
    logger.d(await KakaoSdk.origin);
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        logger.d('카카오톡으로 로그인 성공');
      } catch (e) {
        logger.e(e);

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (e is PlatformException && e.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          logger.d('카카오계정으로 로그인 성공');
        } catch (error) {
          logger.d('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        logger.d('카카오계정으로 로그인 성공');
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
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    context.loaderOverlay.show();
                    await Future.delayed(const Duration(seconds: 2));
                    context.loaderOverlay.hide();
                  },
                  child: const FilledButtonWidget(
                    text: '로딩',
                    isEnable: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingleNationalFlagScreen(),
                      ));
                },
                child: const FullBleedButtonWidget(
                  text: '다음(국적)',
                  isEnable: true,
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
              const SizedBox(
                height: 10,
              ),
              // Select Component
              SelectWidget(
                leftText: 'text',
                rightText: 'text',
                value: selectWidgetValueType,
                onTapLeft: () {
                  setState(() {
                    selectWidgetValueType = SelectWidgetValueType.left;
                  });
                },
                onTapRight: () {
                  setState(() {
                    selectWidgetValueType = SelectWidgetValueType.right;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  controller: TextEditingController(),
                  onChanged: (value) {
                    logger.d('onChanged:$value');
                  },
                  onFieldSubmitted: (p0) {
                    logger.d('onFieldSubmitted:$p0');
                  },
                  hintText: 'Placeholder',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  showDefaultModalBottomSheet(
                    context: context,
                    title: '소속 확인',
                    titleLeftButton: true,
                    titleRightButton: true,
                  );
                },
                child: const Text('BottomSheet'),
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
}
