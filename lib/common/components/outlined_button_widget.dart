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
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
  final int? maxLines;
  const OutlinedButtonWidget({
    Key? key,
    required this.text,
    required this.isEnable,
    this.leftIconPath,
    this.height = 56,
    this.textAlign,
    this.alignment = Alignment.center,
    this.maxLines = 2,
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
          color: kColorBorderStrong,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leftIconPath != null)
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 4),
              child: SvgPicture.asset(
                leftIconPath!,
                // color: isEnable ? kColorContentWeak : kColorBorderStrong,
                colorFilter: ColorFilter.mode(
                  isEnable ? kColorContentWeak : kColorBorderStrong,
                  BlendMode.srcIn,
                ),
              ),
            ),
          Flexible(
            child: Text(
              text,
              textAlign: textAlign ?? textAlign,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: getTsBody16Sb(context).copyWith(
                color: isEnable ? kColorContentWeak : kColorBorderStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
