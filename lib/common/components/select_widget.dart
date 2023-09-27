// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class SelectWidget extends StatelessWidget {
  final bool isDisable;
  final String text;
  final String iconPath;
  final Function()? onTap;
  const SelectWidget({
    Key? key,
    this.isDisable = false,
    required this.text,
    required this.iconPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: isDisable
                ? getTsBody16Rg(context).copyWith(
                    color: kColorContentWeaker,
                  )
                : getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDisable ? kColorContentPlaceholder : kColorContentDefault,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
