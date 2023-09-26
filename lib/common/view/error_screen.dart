import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/illust_error.svg',
                width: 106,
                height: 116,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                '앗, 뭔가 문제가 생겼어요..',
                style: getTsHeading20(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
