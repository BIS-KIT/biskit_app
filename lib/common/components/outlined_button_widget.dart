// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String text;
  final bool isEnable;
  final String? leftIconPath;
  final double height;
  const OutlinedButtonWidget({
    Key? key,
    required this.text,
    required this.isEnable,
    this.leftIconPath,
    this.height = 56,
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
        border: Border.all(
          width: 1,
          color: kColorGray4,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      alignment: Alignment.center,
      child: leftIconPath == null
          ? Text(
              text,
              style: getTsBody16Sb(context).copyWith(
                color: isEnable ? kColorGray8 : kColorGray4,
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
                    // color: isEnable ? kColorGray8 : kColorGray4,
                    colorFilter: ColorFilter.mode(
                      isEnable ? kColorGray8 : kColorGray4,
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
                    color: isEnable ? kColorGray8 : kColorGray4,
                  ),
                ),
              ],
            ),
    );
  }
}
