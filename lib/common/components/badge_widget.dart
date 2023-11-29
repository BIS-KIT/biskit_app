import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

enum BadgeSizeType { M, L }

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isShowLeftIcon;
  final bool isShowRightIcon;
  final BadgeSizeType sizeType;
  const BadgeWidget({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isShowLeftIcon = false,
    this.isShowRightIcon = false,
    required this.sizeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: sizeType == BadgeSizeType.L ? 6 : 4,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? kColorBgElevation2,
        borderRadius: BorderRadius.all(
          Radius.circular(sizeType == BadgeSizeType.L ? 8 : 6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isShowLeftIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: sizeType == BadgeSizeType.L ? 16 : 12,
              height: sizeType == BadgeSizeType.L ? 16 : 12,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: Text(
              text,
              style: sizeType == BadgeSizeType.L
                  ? kTsEnBody14Sb.copyWith(
                      color: textColor ?? kColorContentWeaker,
                    )
                  : kTsKrCaption12Sb.copyWith(
                      color: textColor ?? kColorContentWeaker,
                    ),
            ),
          ),
          if (isShowRightIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: sizeType == BadgeSizeType.L ? 16 : 12,
              height: sizeType == BadgeSizeType.L ? 16 : 12,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
