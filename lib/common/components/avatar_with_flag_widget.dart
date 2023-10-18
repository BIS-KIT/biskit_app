import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/const/colors.dart';

class AvatarWithFlagWidget extends StatelessWidget {
  final String? profilePath;
  final String? flagPath;
  const AvatarWithFlagWidget({
    Key? key,
    this.profilePath,
    this.flagPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 16,
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
            width: 16,
            height: 16,
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
                      width: 16,
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
