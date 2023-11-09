import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/list_widget_temp.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/components/radio_widget.dart';
import 'package:biskit_app/common/components/select_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/error_screen.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/common/view/place_search_screen.dart';
import 'package:biskit_app/common/view/single_national_flag_screen.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_nickname_screen.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/set_password_completed_screen.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:biskit_app/user/view/sign_up_completed_screen.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:biskit_app/profile/view/profile_language_screen.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../components/check_circle.dart';
import '../utils/date_util.dart';
import 'name_birth_gender_screen.dart';

class TestScreen extends ConsumerStatefulWidget {
  static String get routeName => 'test';
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  RadioWidgetValueType radioWidgetValueType = RadioWidgetValueType.none;
  bool isChecked = false;
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
      title: 'Test1 Screen',
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhotoManagerScreen(
                        isCamera: true,
                        maxCnt: 30,
                      ),
                    ),
                  );
                  logger.d(result);
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
                        builder: (context) => SingleNationalFlagScreen(
                          signUpModel: SignUpModel(),
                        ),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NameBirthGenderScreen(
                          signUpModel: SignUpModel(),
                        ),
                      ));
                },
                child: const FullBleedButtonWidget(
                  text: '다음(이름생일성별)',
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
              // Select Component
              RadioWidget(
                leftText: 'text',
                rightText: 'text',
                value: radioWidgetValueType,
                onTapLeft: () {
                  setState(() {
                    radioWidgetValueType = RadioWidgetValueType.left;
                  });
                },
                onTapRight: () {
                  setState(() {
                    radioWidgetValueType = RadioWidgetValueType.right;
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
              ListWidgetTemp(
                onTap: () {
                  logger.d('onTap');
                },
                touchWidget: const CheckCircleWidget(
                  value: true,
                ),
                centerWidget: Text(
                  'Text',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
                rightWidget: SelectWidget(
                  onTap: () {
                    logger.d('rightWidget onTap');
                  },
                  usageType: 'title',
                  text: 'Label',
                  iconPath: 'assets/icons/ic_chevron_down_line_24.svg',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListWidgetTemp(
                onTap: () {
                  logger.d('onTap');
                },
                touchWidget: const CheckCircleWidget(
                  value: true,
                ),
                centerWidget: Text(
                  'Text',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeak,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CheckCircleWidget(
                value: isChecked,
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectWidget(
                    text: 'Label',
                    usageType: 'body',
                    iconPath: 'assets/icons/ic_chevron_down_line_24.svg',
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SelectWidget(
                    text: 'Label',
                    usageType: 'title',
                    iconPath: 'assets/icons/ic_chevron_down_line_24.svg',
                  ),
                ],
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
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetPasswordScreen(
                          title: '',
                        ),
                      ));
                },
                child: const Text('비밀번호 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SetPasswordCompletedScreen(),
                      ));
                },
                child: const Text('비밀번호 재설정 완료화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpCompletedScreen(),
                      ));
                },
                child: const Text('회원가입 완료 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileNicknameScreen(),
                      ));
                },
                child: const Text('프로필 닉네임 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleNationalFlagScreen(
                          signUpModel: SignUpModel(),
                        ),
                      ));
                },
                child: const Text('국적 선택 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversityScreen(
                          signUpModel: SignUpModel(
                            email: 'test00@gmail.com',
                            password: 'qwer1234',
                            birth: '1990-01-06',
                            gender: 'male',
                            name: '테스터',
                            terms_mandatory: true,
                            terms_optional: true,
                            terms_push: true,
                            nationality_ids: [1],
                          ),
                        ),
                      ));
                },
                child: const Text('학교 선택 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileLanguageScreen(),
                      ));
                },
                child: const Text('사용언어 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileKeywordScreen(
                          profileCreateModel: ProfileCreateModel(
                            nick_name: '딱딱한비스킷이야임뫄짜식',
                            profile_photo: null,
                            available_languages: [],
                            introductions: [],
                          ),
                        ),
                      ));
                },
                child: const Text('키워드 화면'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileIdConfirmScreen(
                          profileCreateModel: ProfileCreateModel(
                            nick_name: '딱딱한비스킷이야임뫄짜식',
                            profile_photo: null,
                            available_languages: [],
                            introductions: [],
                          ),
                        ),
                      ));
                },
                child: const Text('학생증 인증 화면'),
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showBiskitBottomSheet(
                        context: context,
                        title: '장소 검색',
                        rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            44,
                        contentWidget: const PlaceSearchScreen(
                          isEng: false,
                        ),
                        onRightTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: const Text('장소 선택 화면(한글)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showBiskitBottomSheet(
                        context: context,
                        title: '장소 검색',
                        rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            44,
                        contentWidget: const PlaceSearchScreen(
                          isEng: true,
                        ),
                        onRightTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: const Text('장소 선택 화면(영문)'),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              ElevatedButton(
                onPressed: () async {
                  DateTime dateTime = getDateTimeIntervalMin5();
                  final time = await showTimeBottomSheet(
                    context: context,
                    time: dateTime,
                    // onDateTimeChanged: (newTime) {
                    //   // setState(() {
                    //   // });
                    //   dateTime = newTime;
                    // },
                  );
                  logger.d(time);
                },
                child: const Text('시간 선택'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ErrorScreen(),
                      ));
                },
                child: const Text('error 화면'),
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
