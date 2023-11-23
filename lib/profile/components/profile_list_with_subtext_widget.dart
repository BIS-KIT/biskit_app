import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/profile/model/introduction_model.dart';
import 'package:biskit_app/user/model/user_nationality_model.dart';

class ProfileListWithSubtextWidget extends StatefulWidget {
  final UserNationalityModel userNationalityModel;
  final String name;
  final bool isCreator;
  final String? profilePath;
  final String subText;
  // final UserUniversityModel universityModel;
  final List<IntroductionModel> introductions;
  final VoidCallback onTap;
  const ProfileListWithSubtextWidget({
    Key? key,
    required this.userNationalityModel,
    required this.name,
    required this.isCreator,
    this.profilePath,
    required this.subText,
    // required this.universityModel,
    required this.introductions,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ProfileListWithSubtextWidget> createState() =>
      _ProfileListWithSubtextWidgetState();
}

class _ProfileListWithSubtextWidgetState
    extends State<ProfileListWithSubtextWidget> {
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
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        color: _pressed ? kColorBgElevation1 : kColorBgDefault,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWithFlagWidget(
              radius: 20,
              flagRadius: 16,
              profilePath: widget.profilePath,
              flagPath:
                  '$kS3Url$kS3Flag43Path/${widget.userNationalityModel.nationality.code}.svg',
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.name,
                            style: getTsBody16Sb(context).copyWith(
                              color: kColorContentWeak,
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
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.subText,
                        // "${widget.universityModel.university.kr_name} · ${widget.universityModel.department} ${widget.universityModel.education_status}",
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                    ],
                  ),
                  if (widget.introductions.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            ...widget.introductions.map(
                              (introduction) => BadgeWidget(
                                text: introduction.keyword,
                                backgroundColor: kColorBgElevation1,
                                textColor: kColorContentWeaker,
                              ),
                            ),
                          ],
                        ),
                      ],
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
