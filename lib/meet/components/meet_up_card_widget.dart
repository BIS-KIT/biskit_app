import 'package:biskit_app/common/components/flag_widget.dart';
import 'package:biskit_app/common/components/new_badge_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MeetUpCardSizeType { L, M }

class MeetUpCardWidget extends StatefulWidget {
  final MeetUpModel model;
  final VoidCallback onTapMeetUp;
  final MeetUpCardSizeType sizeType;
  final double width;
  final bool isHostTag;
  final bool isParticipantsStatusTag;
  final UserModelBase? userModel;
  final UserSystemModelBase? systemModel;
  const MeetUpCardWidget({
    Key? key,
    required this.model,
    required this.onTapMeetUp,
    this.sizeType = MeetUpCardSizeType.L,
    this.width = 277,
    this.isHostTag = false,
    this.isParticipantsStatusTag = true,
    required this.userModel,
    required this.systemModel,
  }) : super(key: key);

  @override
  State<MeetUpCardWidget> createState() => _MeetUpCardWidgetState();
}

class _MeetUpCardWidgetState extends State<MeetUpCardWidget> {
  // String getRecruitmentBadgeStr() {
  //   String str = '';

  //   if (widget.userModel != null && widget.userModel is UserModel) {
  //     bool isKorean = false;
  //     if ((widget.userModel as UserModel)
  //         .user_nationality
  //         .where((element) => element.nationality.code.toLowerCase() == 'kr')
  //         .isNotEmpty) {
  //       isKorean = true;
  //     }
  //     if (isKorean) {
  //       str = '한국인 모집';
  //     } else {
  //       str = '외국인 모집';
  //     }
  //   }

  //   return str;
  // }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatUS = DateFormat('MM/dd (EEE)', 'en_US');
    final DateFormat dateFormatKO = DateFormat('MM/dd (EEE)', 'ko_KR');
    final DateFormat timeFormatUS = DateFormat('a h:mm', 'en_US');
    final DateFormat timeFormatKO = DateFormat('a h:mm', 'ko_KR');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        widget.onTapMeetUp();
      },
      child: Container(
        width: widget.sizeType == MeetUpCardSizeType.L ? null : widget.width,
        height: widget.sizeType == MeetUpCardSizeType.L ? null : 186,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: kColorBgDefault,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThumbnailIconWidget(
                  size: 52,
                  iconSize: 44,
                  padding: 4,
                  isSelected: false,
                  radius: 12,
                  iconPath: widget.model.image_url ?? kCategoryDefaultPath,
                  thumbnailIconType: ThumbnailIconType.network,
                ),
                // Container(
                //   padding: const EdgeInsets.all(4),
                //   decoration: BoxDecoration(
                //     color: kColorBgPrimaryWeak,
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(
                //         widget.sizeType == MeetUpCardSizeType.L ? 12 : 8,
                //       ),
                //     ),
                //   ),
                //   child: SvgPicture.asset(
                //     'assets/icons/ic_hobby_fill_48.svg',
                //     width: widget.sizeType == MeetUpCardSizeType.L ? 44 : 32,
                //     height: widget.sizeType == MeetUpCardSizeType.L ? 44 : 32,
                //   ),
                // ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_person_fill_24.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        kColorContentWeaker,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.model.current_participants.toString(),
                          style: getTsCaption12Sb(context).copyWith(
                            color: kColorContentWeaker,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '/',
                          style: getTsCaption12Rg(context).copyWith(
                            color: kColorContentWeakest,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.model.max_participants.toString(),
                          style: getTsCaption12Sb(context).copyWith(
                            color: kColorContentWeakest,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (widget.isHostTag)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: kColorBgSecondaryWeak,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          'selectReviewScreen.host'.tr(),
                          style: getTsCaption12Sb(context).copyWith(
                            color: kColorContentSecondary,
                          ),
                        ),
                      ),
                    if (widget.isHostTag)
                      const SizedBox(
                        width: 6,
                      ),
                    if (widget.isParticipantsStatusTag)
                      Builder(builder: (context) {
                        bool isKorean = false;
                        if ((widget.userModel as UserModel)
                            .user_nationality
                            .where((element) =>
                                element.nationality.code.toLowerCase() == 'kr')
                            .isNotEmpty) {
                          isKorean = true;
                        }
                        if (isKorean && widget.model.korean_count == 0) {
                          return const NewBadgeWidget(
                            text: '한국인 모집',
                            type: BadgeType.secondary,
                            size: BadgeSize.M,
                          );
                        } else if (!isKorean &&
                            widget.model.foreign_count == 0) {
                          return const NewBadgeWidget(
                            text: '외국인 모집',
                            type: BadgeType.secondary,
                            size: BadgeSize.M,
                          );
                        } else {
                          return Container();
                        }
                      })
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getTsBody16Sb(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            widget.sizeType == MeetUpCardSizeType.L
                ? const SizedBox(
                    height: 8,
                  )
                : const Spacer(),
            widget.sizeType == MeetUpCardSizeType.L
                ? Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FlagWidget(
                        flagCode: widget
                            .model.creator.user_nationality[0].nationality.code,
                        size: 16,
                      ),
                      // const CircleAvatar(
                      //   radius: 8,
                      //   backgroundColor: Colors.amber,
                      // ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        getMeetUpDateStr(
                          meetUpDateStr: widget.model.meeting_time,
                          dateFormat: widget.systemModel is UserSystemModel &&
                                  (widget.systemModel as UserSystemModel)
                                          .system_language ==
                                      'kr'
                              ? dateFormatKO
                              : dateFormatUS,
                        ),
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '·',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeakest,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.model.meeting_time.isEmpty
                            ? ''
                            : widget.systemModel is UserSystemModel &&
                                    (widget.systemModel as UserSystemModel)
                                            .system_language ==
                                        'kr'
                                ? timeFormatKO.format(
                                    DateTime.parse(widget.model.meeting_time))
                                : timeFormatUS.format(
                                    DateTime.parse(widget.model.meeting_time)),
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '·',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeakest,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.model.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          FlagWidget(
                            flagCode: widget.model.creator.user_nationality[0]
                                .nationality.code,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            getMeetUpDateStr(
                                meetUpDateStr: widget.model.meeting_time,
                                dateFormat: widget.systemModel
                                            is UserSystemModel &&
                                        (widget.systemModel as UserSystemModel)
                                                .system_language ==
                                            'kr'
                                    ? dateFormatKO
                                    : dateFormatUS),
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeaker,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '·',
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.model.meeting_time.isEmpty
                                ? ''
                                : widget.systemModel is UserSystemModel &&
                                        (widget.systemModel as UserSystemModel)
                                                .system_language ==
                                            'kr'
                                    ? timeFormatKO.format(DateTime.parse(
                                        widget.model.meeting_time))
                                    : timeFormatUS.format(DateTime.parse(
                                        widget.model.meeting_time)),
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeaker,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_pin_fill_24.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              kColorContentWeakest,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              widget.model.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTsBody14Rg(context).copyWith(
                                color: kColorContentWeaker,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            if (widget.sizeType == MeetUpCardSizeType.L)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  ExtendedWrap(
                    spacing: 6,
                    runSpacing: 6,
                    maxLines: 2,
                    children: widget.model.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: const BoxDecoration(
                              color: kColorBgElevation2,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              tag.is_custom
                                  ? tag.kr_name.isNotEmpty
                                      ? tag.kr_name
                                      : tag.en_name
                                  : widget.systemModel is UserSystemModel &&
                                          (widget.systemModel
                                                      as UserSystemModel)
                                                  .system_language ==
                                              'kr'
                                      ? tag.kr_name
                                      : tag.en_name,
                              style: getTsCaption12Rg(context).copyWith(
                                color: kColorContentWeaker,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
