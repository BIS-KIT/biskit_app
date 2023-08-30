import 'package:flutter/material.dart';

import '../layout/default_layout.dart';
import '../utils/logger_util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context) {
    logger.d('SplashScreen build');
    return DefaultLayout(
      backgroundColor: const Color(0xffFEF076),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-1.png',
              fit: BoxFit.contain,
              width: 184,
              height: 86,
            ),
          ],
        ),
      ),
    );
  }
}
