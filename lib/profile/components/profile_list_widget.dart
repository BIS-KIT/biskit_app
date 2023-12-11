import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/user/model/user_nationality_model.dart';

class ProfileListWidget extends StatefulWidget {
  final UserNationalityModel userNationalityModel;
  final String name;
  final bool isCreator;
  final String? profilePath;
  final VoidCallback onTap;
  final Color backgroundColor;
  const ProfileListWidget({
    Key? key,
    required this.userNationalityModel,
    required this.name,
    required this.isCreator,
    this.profilePath,
    required this.onTap,
    this.backgroundColor = kColorBgDefault,
  }) : super(key: key);

  @override
  State<ProfileListWidget> createState() => _ProfileListWidgetState();
}

class _ProfileListWidgetState extends State<ProfileListWidget> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (details) async {
        setState(() {
          _pressed = false;
        });
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: _pressed ? kColorBgElevation1 : widget.backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarWithFlagWidget(
              radius: 20,
              flagRadius: 16,
              profilePath: widget.profilePath,
              flagPath:
                  '$kS3HttpUrl$kS3Flag43Path/${widget.userNationalityModel.nationality.code}.svg',
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTsBody16Sb(context).copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  if (widget.isCreator)
                    SvgPicture.asset(
                      'assets/icons/ic_crown_circle_fill_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
