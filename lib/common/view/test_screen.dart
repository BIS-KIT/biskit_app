import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static String get routeName => 'test';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
            const Text(
              '사진첩 테스트',
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                '갤러리',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
