import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/const/colors.dart';

enum ThumbnailIconType { assets, network }

class ThumbnailIconWidget extends StatelessWidget {
  final double size;
  final double iconSize;
  final double padding;
  final bool isSelected;
  final double radius;
  final String? iconPath;
  final Color? iconColor;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final ThumbnailIconType thumbnailIconType;
  const ThumbnailIconWidget({
    Key? key,
    required this.size,
    this.iconSize = 72,
    this.iconColor,
    this.padding = 8,
    required this.isSelected,
    required this.radius,
    required this.iconPath,
    this.backgroundColor = kColorBgPrimaryWeak,
    this.selectedBackgroundColor = kColorBgPrimaryWeak,
    this.thumbnailIconType = ThumbnailIconType.assets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isSelected ? selectedBackgroundColor : backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        border: isSelected
            ? Border.all(
                width: 2,
                color: kColorBorderPrimaryStrong,
              )
            : null,
      ),
      child: iconPath == null
          ? null
          : thumbnailIconType == ThumbnailIconType.assets
              ? SvgPicture.asset(
                  iconPath!,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.fitWidth,
                  colorFilter: iconColor == null
                      ? null
                      : ColorFilter.mode(
                          iconColor!,
                          BlendMode.srcIn,
                        ),
                )
              : SvgPicture.network(
                  iconPath!,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.fitWidth,
                  colorFilter: iconColor == null
                      ? null
                      : ColorFilter.mode(
                          iconColor!,
                          BlendMode.srcIn,
                        ),
                ),
    );
  }
}

// enum ThumbnailIconSizeType { large, medium, small }

// class ThumbnailIconWidget extends StatelessWidget {
//   final bool isSelected;
//   final String iconUrl;
//   final bool isCircle;
//   final ThumbnailIconSizeType sizeType;
//   const ThumbnailIconWidget({
//     Key? key,
//     this.isSelected = false,
//     this.iconUrl = 'assets/icons/ic_restaurant_fill_48.svg',
//     this.isCircle = true,
//     this.sizeType = ThumbnailIconSizeType.large,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double size = 88;
//     double iconSize = 48;
//     double position = 20;
//     if (sizeType == ThumbnailIconSizeType.medium) {
//       size = 64;
//       iconSize = 36;
//       position = 14;
//     } else if (sizeType == ThumbnailIconSizeType.small) {
//       size = 52;
//       iconSize = 28;
//       position = 12;
//     }
//     if (isCircle) {
//       return Stack(
//         children: [
//           Container(
//             width: size,
//             height: size,
//             decoration: ShapeDecoration(
//               color: kColorBgElevation2,
//               shape: RoundedRectangleBorder(
//                 side: isSelected
//                     ? const BorderSide(width: 3, color: Color(0xFF677389))
//                     : BorderSide.none,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//             ),
//           ),
//           Positioned(
//             top: position,
//             left: position,
//             child: SvgPicture.asset(
//               iconUrl,
//               width: iconSize,
//               height: iconSize,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Container(
//         padding: const EdgeInsets.all(12),
//         decoration: const BoxDecoration(
//           color: kColorBgElevation2,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         child: SvgPicture.asset(
//           iconUrl,
//           width: 28,
//           height: 28,
//         ),
//       );
//     }
//   }
// }
