// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class SelectWidget extends StatelessWidget {
  final String usageType;
  final String text;
  final String? iconPath;
  final Function()? onTap;
  const SelectWidget({
    Key? key,
    required this.usageType,
    required this.text,
    required this.iconPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: usageType == 'body'
                ? getTsBody16Rg(context).copyWith(
                    color: kColorContentWeaker,
                  )
                : getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
          ),
          if (iconPath != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath!,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    usageType == 'body'
                        ? kColorContentWeakest
                        : kColorContentDefault,
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
