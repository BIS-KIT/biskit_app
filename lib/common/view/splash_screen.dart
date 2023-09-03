import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo-1.svg',
            ),
          ],
        ),
      ),
    );
  }
}
