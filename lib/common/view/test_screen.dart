import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.d(context.locale.toString());
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.setLocale(const Locale('ko', 'KR'));
          // context.setLocale(const Locale('en', 'US'));
        },
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('hello').tr(),
          ],
        ),
      ),
    );
  }
}
