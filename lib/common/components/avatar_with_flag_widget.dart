import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';

class AvatarWithFlagWidget extends StatelessWidget {
  final String? profilePath;
  final String? flagPath;
  final double? radius;
  final double? flagRadius;
  const AvatarWithFlagWidget({
    Key? key,
    this.profilePath,
    this.flagPath,
    this.radius = 16,
    this.flagRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: const AssetImage(
            'assets/images/88.png',
          ),
          foregroundImage:
              profilePath == null ? null : NetworkImage(profilePath!),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: flagRadius,
            height: flagRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: kColorBorderStrong,
                width: 1,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: flagPath == null
                ? Container()
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: SvgPicture.network(
                      flagPath!,
                      width: flagRadius,
                      height: flagRadius,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
