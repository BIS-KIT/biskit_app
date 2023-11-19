import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThumbnailIconNotifyWidget extends StatelessWidget {
  final String iconUrl;
  final Color iconColor;
  final Color backgroundColor;
  const ThumbnailIconNotifyWidget({
    Key? key,
    this.iconUrl = 'assets/icons/ic_person_fill_24.svg',
    this.iconColor = kColorContentSecondary,
    this.backgroundColor = kColorBgElevation2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SvgPicture.asset(
        iconUrl,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
