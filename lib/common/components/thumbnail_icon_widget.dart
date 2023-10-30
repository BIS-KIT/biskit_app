import 'package:biskit_app/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThumbnailIconWidget extends StatelessWidget {
  final bool isSelected;
  final String iconUrl;
  const ThumbnailIconWidget({
    Key? key,
    this.isSelected = false,
    this.iconUrl = 'assets/icons/ic_restaurant_fill_48.svg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: ShapeDecoration(
            color: const Color(0xFFF1F4F9),
            shape: RoundedRectangleBorder(
              side: isSelected
                  ? const BorderSide(width: 3, color: Color(0xFF677389))
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Positioned(
            top: 20,
            left: 20,
            child: SvgPicture.asset(
              iconUrl,
              width: 48,
              height: 48,
              colorFilter: const ColorFilter.mode(
                kColorContentSecondary,
                BlendMode.srcIn,
              ),
            ))
      ],
    );
  }
}
