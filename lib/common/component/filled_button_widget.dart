// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class FilledButtonWidget extends StatelessWidget {
  final String text;
  final bool isEnable;
  final String? leftIconPath;
  const FilledButtonWidget({
    Key? key,
    required this.text,
    required this.isEnable,
    this.leftIconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: isEnable ? kColorYellow3 : kColorGray2,
        border: Border.all(
          width: 0.5,
          color: isEnable ? kColorYellow3 : kColorGray2,
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
                color: isEnable ? kColorGray9 : kColorGray5,
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
                      isEnable ? kColorGray9 : kColorGray5,
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
                    color: isEnable ? kColorGray9 : kColorGray5,
                  ),
                ),
              ],
            ),
    );
  }
}
