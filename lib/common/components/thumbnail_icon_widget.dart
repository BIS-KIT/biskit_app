import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ThumbnailIconSizeType { large, medium, small }

class ThumbnailIconWidget extends StatelessWidget {
  final bool isSelected;
  final String iconUrl;
  final bool isCircle;
  final ThumbnailIconSizeType sizeType;
  final Color iconColor;
  const ThumbnailIconWidget({
    Key? key,
    this.isSelected = false,
    this.iconUrl = 'assets/icons/ic_restaurant_fill_48.svg',
    this.isCircle = true,
    this.sizeType = ThumbnailIconSizeType.large,
    this.iconColor = kColorContentSecondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 88;
    double iconSize = 48;
    double position = 20;
    if (sizeType == ThumbnailIconSizeType.medium) {
      size = 64;
      iconSize = 36;
      position = 14;
    } else if (sizeType == ThumbnailIconSizeType.small) {
      size = 52;
      iconSize = 28;
      position = 12;
    }
    if (isCircle) {
      return Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: ShapeDecoration(
              color: kColorBgElevation2,
              shape: RoundedRectangleBorder(
                side: isSelected
                    ? const BorderSide(width: 3, color: Color(0xFF677389))
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: position,
            left: position,
            child: SvgPicture.asset(
              iconUrl,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: kColorBgElevation2,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: SvgPicture.asset(
          iconUrl,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        ),
      );
    }
  }
}
