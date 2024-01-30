import 'dart:io';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/test2_screen.dart';
import 'package:biskit_app/common/view/test_screen.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:biskit_app/user/view/sign_up_agree_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // google login
  signInWithGoogle() async {
    UserCredential? userCredential;
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    }
    logger.d(
        'signInWithGoogle.FirebaseAuth.instance.signInWithCredential(credential)>>>[${userCredential.user!.uid}]$userCredential');
    if (userCredential.user != null) {
      await login(
        snsEmail: userCredential.user!.email,
        snsId: userCredential.user!.uid,
        snsType: SnsType.google,
      );
    }
  }

  // apple login
  signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      logger.d('_authResult : ${authResult.toString()}');
      // is_private_email : true 인 경우 이메일 가리기 처리 한 상태
      if (authResult.user != null) {
        await login(
          // email: authResult.user!.email,
          snsId: authResult.user!.uid,
          snsType: SnsType.apple,
          snsEmail: appleCredential.email,
          iOsFirstName: appleCredential.givenName,
          iOsLastName: appleCredential.familyName,
        );
      }
    } catch (error) {
      logger.d(error);
    }
  }

  // Kakao Login
  void signInWithKakao() async {
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        logger.d('카카오톡으로 로그인 성공');
      } catch (error) {
        logger.d('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          final kakao.OAuthToken result =
              await kakao.UserApi.instance.loginWithKakaoAccount();
          logger.d('카카오계정으로 로그인 성공 : ${result.toJson()}');
        } catch (error) {
          logger.d('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        final kakao.OAuthToken result =
            await kakao.UserApi.instance.loginWithKakaoAccount();
        logger.d('카카오계정으로 로그인 성공 : ${result.toJson()}');
      } catch (error) {
        logger.d('카카오계정으로 로그인 실패 $error');
      }
    }

    kakao.User user = await kakao.UserApi.instance.me();
    logger.d('사용자 정보 요청 성공'
        '\n회원번호: ${user.id}'
        '\nkakaoAccount: ${user.kakaoAccount?.toJson()}');

    await login(
      snsEmail: user.kakaoAccount == null ? null : user.kakaoAccount!.email,
      snsId: user.id.toString(),
      snsType: SnsType.kakao,
    );
  }

  login({
    required String snsId,
    required SnsType snsType,
    String? snsEmail,
    String? iOsLastName,
    String? iOsFirstName,
  }) async {
    UserModelBase? userModelBase =
        await ref.read(userMeProvider.notifier).login(
              snsId: snsId,
              snsType: snsType,
            );
    logger.d(userModelBase);
    if (!mounted) return;
    if (userModelBase == null) {
      // 가입된 아이디 없으면 회원가입 처리
      if (!mounted) return;
      context.pushNamed(
        SignUpAgreeScreen.routeName,
        extra: snsType == SnsType.apple
            ? SignUpModel(
                sns_type: snsType.name,
                sns_id: snsId,
                email: snsEmail,
                name: '$iOsFirstName $iOsLastName',
              )
            : SignUpModel(
                sns_type: snsType.name,
                sns_id: snsId,
                email: snsEmail ?? '',
              ),
      );
    } else if (userModelBase is UserModelError) {
      showSnackBar(
        context: context,
        text: userModelBase.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return DefaultLayout(
      brightness: Brightness.light,
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
          : null,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: padding.top,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/login-background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: padding.top,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0, -1),
                end: const Alignment(0, 1),
                colors: [
                  Colors.black.withOpacity(0.21),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: padding.top,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '글로벌한\n대학생활의 시작\nBISKIT',
                        style: TextStyle(
                          color: kColorContentInverse,
                          fontSize: 32,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '우리 학교 다양한 국적의\n친구들과 만나보세요',
                        style: getTsBody16Rg(context).copyWith(
                          color: kColorContentInverse,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: signInWithKakao,
                        child: _buildKakao(context),
                      ),
                      if (Platform.isIOS)
                        GestureDetector(
                          onTap: signInWithApple,
                          child: _buildApple(context),
                        ),
                      GestureDetector(
                        onTap: signInWithGoogle,
                        child: _buildGoogle(context),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.goNamed(EmailLoginScreen.routeName);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const EmailLoginScreen(),
                          //   ),
                          // );
                        },
                        child: _buildEmail(context),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
            color: Colors.white,
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

  Container _buildEmail(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(
        // vertical: 14,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
          // color: kColorBgElevation1,
          // border: Border.all(
          //   width: 1,
          //   color: kColorBgElevation3,
          // ),
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(6),
          // ),
          ),
      alignment: Alignment.center,
      child: Row(
        children: [
          // SvgPicture.asset(
          //   'assets/icons/ic_mail_line_24.svg',
          //   width: 24,
          //   height: 24,
          //   colorFilter: const ColorFilter.mode(
          //     kColorContentWeak,
          //     BlendMode.srcIn,
          //   ),
          // ),
          Expanded(
            child: Text(
              '이메일로 로그인',
              textAlign: TextAlign.center,
              style: getTsBody16Sb(context).copyWith(
                color: kColorContentInverse,
                decoration: TextDecoration.underline,
                decorationColor: kColorContentInverse,
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
            color: Colors.white,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kColorContentWeak,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      '로 로그인',
                      textAlign: TextAlign.center,
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                  ],
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
