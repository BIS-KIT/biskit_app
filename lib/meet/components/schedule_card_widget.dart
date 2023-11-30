import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';

class ScheduleCardWidget extends StatelessWidget {
  final MeetUpModel meetUpModel;
  final double width;
  const ScheduleCardWidget({
    Key? key,
    required this.meetUpModel,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
    final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetUpDetailScreen(meetUpModel: meetUpModel),
          ),
        );
      },
      child: Container(
        width: width,
        height: 249,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x11495B7D),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x07495B7D),
              blurRadius: 1,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            // Section1
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                color: kColorBgElevation1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        meetUpModel.meeting_time.isEmpty
                            ? ''
                            : dateFormat1.format(
                                DateTime.parse(meetUpModel.meeting_time)),
                        style: getTsHeading18(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        meetUpModel.meeting_time.isEmpty
                            ? ''
                            : dateFormat2.format(
                                DateTime.parse(meetUpModel.meeting_time)),
                        style: getTsHeading18(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_pin_fill_24.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          kColorContentWeaker,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        meetUpModel.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTsBody16Sb(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Section2
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 20,
                bottom: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: kColorBgDefault,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ThumbnailIconWidget(
                        size: 40,
                        padding: 4,
                        iconSize: 24,
                        isSelected: false,
                        radius: 8,
                        iconPath: meetUpModel.image_url ?? kCategoryDefaultPath,
                        thumbnailIconType: ThumbnailIconType.network,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          meetUpModel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getTsBody14Rg(context).copyWith(
                            color: kColorContentWeaker,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const OutlinedButtonWidget(
                    text: '채팅',
                    isEnable: true,
                    height: 40,
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
