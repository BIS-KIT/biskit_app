import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/name_birth_gender_screen.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/common/view/root_tab.dart';
import 'package:biskit_app/common/view/single_national_flag_screen.dart';
import 'package:biskit_app/common/view/splash_screen.dart';
import 'package:biskit_app/meet/view/my_meet_up_list_screen.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:biskit_app/profile/view/profile_language_screen.dart';
import 'package:biskit_app/profile/view/profile_nickname_screen.dart';
import 'package:biskit_app/review/view/review_view_screen.dart';
import 'package:biskit_app/setting/view/announcement_screen.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:biskit_app/user/view/find_id_screen.dart';
import 'package:biskit_app/user/view/find_password_screen.dart';
import 'package:biskit_app/user/view/login_screen.dart';
import 'package:biskit_app/user/view/set_password_completed_screen.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:biskit_app/user/view/sign_up_agree_screen.dart';
import 'package:biskit_app/user/view/sign_up_completed_screen.dart';
import 'package:biskit_app/user/view/sign_up_email_screen.dart';
import 'package:biskit_app/user/view/sign_up_screen.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  final provider = ref.read(routeProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});

final routeProvider = ChangeNotifierProvider<RouteProvider>((ref) {
  return RouteProvider(ref: ref);
});

class RouteProvider extends ChangeNotifier {
  final Ref ref;
  RouteProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'emailLogin',
              name: EmailLoginScreen.routeName,
              builder: (_, state) {
                return EmailLoginScreen(
                  email: state.uri.queryParameters['email'],
                );
              },
              routes: [
                GoRoute(
                  path: 'signUpAgree',
                  name: SignUpAgreeScreen.routeName,
                  builder: (_, state) {
                    return SignUpAgreeScreen(
                      signUpModel: state.extra as SignUpModel,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'signUpEmail',
                      name: SignUpEmailScreen.routeName,
                      builder: (_, state) {
                        return SignUpEmailScreen(
                          signUpModel: state.extra as SignUpModel,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'signUpPassword',
                          name: SetPasswordScreen.routeName,
                          builder: (_, state) => SetPasswordScreen(
                            pageType: PageType.register,
                            signUpModel: state.extra as SignUpModel,
                          ),
                          routes: [
                            GoRoute(
                              path: 'nameBirthGender',
                              name: NameBirthGenderScreen.routeName,
                              builder: (_, state) => NameBirthGenderScreen(
                                signUpModel: state.extra as SignUpModel,
                              ),
                              routes: [
                                GoRoute(
                                  path: 'singleNationalFlag',
                                  name: SingleNationalFlagScreen.routeName,
                                  builder: (_, state) =>
                                      SingleNationalFlagScreen(
                                    signUpModel: state.extra as SignUpModel,
                                  ),
                                  routes: [
                                    GoRoute(
                                      path: 'universityScreen',
                                      name: UniversityScreen.routeName,
                                      builder: (_, state) => UniversityScreen(
                                        signUpModel: state.extra as SignUpModel,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/signUpCompleted',
          name: SignUpCompletedScreen.routeName,
          builder: (_, __) => const SignUpCompletedScreen(),
          routes: [
            GoRoute(
              path: 'profileNickname',
              name: ProfileNicknameScreen.routeName,
              builder: (_, __) => const ProfileNicknameScreen(),
              routes: [
                GoRoute(
                  path: 'profileLanguage',
                  name: ProfileLanguageScreen.routeName,
                  builder: (_, state) => ProfileLanguageScreen(
                    profileCreateModel: state.extra as ProfileCreateModel,
                  ),
                  routes: [
                    GoRoute(
                      path: 'profileKeyword',
                      name: ProfileKeywordScreen.routeName,
                      builder: (_, state) => ProfileKeywordScreen(
                        profileCreateModel: state.extra as ProfileCreateModel,
                      ),
                      routes: [
                        GoRoute(
                          path: 'profileIdConfirm',
                          name: ProfileIdConfirmScreen.routeName,
                          builder: (_, state) => ProfileIdConfirmScreen(
                            profileCreateModel:
                                state.extra as ProfileCreateModel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/findId',
          name: FindIdScreen.routeName,
          builder: (_, __) => const FindIdScreen(),
        ),
        GoRoute(
          path: '/signUp',
          name: SignUpScreen.routeName,
          builder: (_, __) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/findPassword',
          name: FindPasswordScreen.routeName,
          builder: (_, __) => const FindPasswordScreen(),
          routes: [
            GoRoute(
              path: 'resetPassword',
              name: 'resetPassword',
              builder: (context, state) =>
                  const SetPasswordScreen(pageType: PageType.find),
            ),
          ],
        ),
        GoRoute(
          path: '/setPasswordCompleted',
          name: SetPasswordCompletedScreen.routeName,
          builder: (context, state) => const SetPasswordCompletedScreen(),
        ),
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => const RootTab(),
          routes: [
            GoRoute(
              path: 'myMeetUpList',
              name: MyMeetUpListScreen.routeName,
              builder: (context, state) => const MyMeetUpListScreen(),
            ),
            GoRoute(
              path: 'reviewView',
              name: ReviewViewScreen.routeName,
              builder: (context, state) {
                return ReviewViewScreen(
                  id: state.extra as int,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/photoManager',
          name: PhotoManagerScreen.routeName,
          builder: (context, state) => const PhotoManagerScreen(),
        ),
        GoRoute(
          path: '/announcement',
          name: AnnouncementScreen.routeName,
          builder: (context, state) => const AnnouncementScreen(),
        ),
      ];

  String? redirectLogic(_, GoRouterState state) {
    logger.d('redirectLogic:${state.matchedLocation}');

    final UserModelBase? user = ref.read(userMeProvider);

    final bool logginIn = [
      '/login',
      '/login/emailLogin',
    ].contains(state.matchedLocation);

    // 유저 정보가 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      // 유저정보 없을때 갈 수 있는 페이지들
      if ([
            '/signUp',
            '/findId',
            '/findPassword',
            '/photoManager',
            '/setPasswordCompleted',
          ].contains(state.matchedLocation) ||
          state.matchedLocation.indexOf('/findPassword') == 0 ||
          state.matchedLocation.indexOf('/login') == 0) {
        return null;
      }
      return logginIn ? null : '/login';
    }

    // user가 null이 아님
    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면
    // 홈으로 이동
    if (user is UserModel) {
      if (user.profile == null ||
          user.profile!.available_languages.isEmpty ||
          user.profile!.introductions.isEmpty) {
        // 만약 프로필 정보가 없다면
        return state.matchedLocation.contains('/signUpCompleted')
            ? null
            : '/signUpCompleted';
      } else {
        return logginIn ||
                ['/splash', '/signUpCompleted'].contains(state.matchedLocation)
            ? '/'
            : null;
      }
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
