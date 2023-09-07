import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/test_screen.dart';
import 'package:biskit_app/user/view/email_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Login Screen',
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(EmailLoginScreen.routeName);
                },
                child: const Text(
                  '이메일 로그인',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(TestScreen.routeName);
                },
                child: const Text(
                  'Test Screen',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
