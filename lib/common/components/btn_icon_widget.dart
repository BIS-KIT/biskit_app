import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';

class BtnIconWidget extends StatelessWidget {
  final String iconPath;
  final double size;
  final bool isDisable;
  final Color backgroundColor;
  final Function()? onTap;
  const BtnIconWidget({
    Key? key,
    required this.iconPath,
    this.size = 52,
    this.isDisable = false,
    this.backgroundColor = kColorBgPrimary,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable ? null : onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDisable ? kColorBgElevation2 : backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            isDisable ? kColorContentDisabled : kColorContentOnBgPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
