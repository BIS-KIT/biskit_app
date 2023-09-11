import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/common/view/root_tab.dart';
import 'package:biskit_app/common/view/splash_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:biskit_app/user/view/find_id_screen.dart';
import 'package:biskit_app/user/view/find_password_screen.dart';
import 'package:biskit_app/user/view/login_screen.dart';
import 'package:biskit_app/user/view/set_password_completed_screen.dart';
import 'package:biskit_app/user/view/set_password_screen.dart';
import 'package:biskit_app/user/view/sign_up_agree_screen.dart';
import 'package:biskit_app/user/view/sign_up_email_screen.dart';
import 'package:biskit_app/user/view/sign_up_pin_code_screen.dart';
import 'package:biskit_app/user/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view/test_screen.dart';

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
  });

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
                  builder: (_, __) => const SignUpAgreeScreen(),
                  routes: [
                    GoRoute(
                      path: 'signUpEmail',
                      name: SignUpEmailScreen.routeName,
                      builder: (_, __) => const SignUpEmailScreen(),
                      routes: [
                        GoRoute(
                          path: 'signUpPinCode/:email',
                          name: SignUpPinCodeScreen.routeName,
                          builder: (_, state) => SignUpPinCodeScreen(
                            email: state.pathParameters['email'] ?? '',
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
        // GoRoute(
        //   path: '/findPassword',
        //   name: FindPasswordScreen.routeName,
        //   builder: (_, __) => const FindPasswordScreen(),
        // ),
        // GoRoute(
        //   path: '/setPassword',
        //   name: SetPasswordScreen.routeName,
        //   builder: (context, state) => const SetPasswordScreen(),
        // ),
        GoRoute(
          path: '/findPassword',
          name: FindPasswordScreen.routeName,
          builder: (_, __) => const FindPasswordScreen(),
          routes: [
            GoRoute(
              path: 'setPassword',
              name: SetPasswordScreen.routeName,
              builder: (context, state) => const SetPasswordScreen(),
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
        ),
        GoRoute(
          path: '/test',
          name: TestScreen.routeName,
          builder: (context, state) => const TestScreen(),
        ),
        GoRoute(
          path: '/photoManager',
          name: PhotoManagerScreen.routeName,
          builder: (context, state) => const PhotoManagerScreen(),
        ),
      ];

  String? redirectLogic(_, GoRouterState state) {
    logger.d('redirectLogic:${state.matchedLocation}');

    final UserModelBase? user = ref.read(userMeProvider);

    final bool logginIn = state.matchedLocation == '/login';

    // 유저 정보가 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      // 유저정보 없을때 갈 수 있는 페이지들
      if ([
            '/signUp',
            '/findId',
            '/findPassword',
            '/test',
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
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
