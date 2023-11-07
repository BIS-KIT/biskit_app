import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final bool isShowLeftIcon;
  final bool isShowRightIcon;
  const BadgeWidget({
    Key? key,
    required this.text,
    this.isShowLeftIcon = false,
    this.isShowRightIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 6,
      ),
      decoration: const BoxDecoration(
        color: kColorBgElevation2,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isShowLeftIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: 16,
              height: 16,
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
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeaker,
              ),
            ),
          ),
          if (isShowRightIcon)
            SvgPicture.asset(
              'assets/icons/ic_cancel_line_24.svg',
              width: 16,
              height: 16,
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
