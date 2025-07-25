// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

enum FontSize {
  l,
  m,
}

class FilledButtonWidget extends StatelessWidget {
  final String text;
  final bool isEnable;
  final String? leftIconPath;
  final double height;
  final Color backgroundColor;
  final Color fontColor;
  final FontSize? fontSize;
  const FilledButtonWidget({
    Key? key,
    required this.text,
    required this.isEnable,
    this.leftIconPath,
    this.height = 56,
    this.backgroundColor = kColorBgPrimary,
    this.fontColor = kColorContentOnBgPrimary,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        // vertical: 14,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: isEnable ? backgroundColor : kColorBgElevation2,
        // border: Border.all(
        //   width: 0.5,
        //   color: isEnable ? kColorYellow3 : kColorGray2,
        // ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      alignment: Alignment.center,
      child: leftIconPath == null
          ? Text(
              text,
              style: (fontSize == FontSize.l
                      ? getTsHeading18(context)
                      : getTsBody16Sb(context))
                  .copyWith(
                color: isEnable ? fontColor : kColorContentDisabled,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    leftIconPath!,
                    colorFilter: ColorFilter.mode(
                      isEnable ? fontColor : kColorContentDisabled,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  text,
                  style: getTsBody16Sb(context).copyWith(
                    color: isEnable ? fontColor : kColorContentDisabled,
                  ),
                ),
              ],
            ),
    );
  }
}
