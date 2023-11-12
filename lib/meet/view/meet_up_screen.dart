// ignore_for_file: non_constant_identifier_names
import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpScreen extends ConsumerStatefulWidget {
  final int meetUpId;
  const MeetUpScreen({
    Key? key,
    required this.meetUpId,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpScreen> createState() => _MeetUpScreenState();
}

class _MeetUpScreenState extends ConsumerState<MeetUpScreen> {
  late MeetUpDetailModel meetUpDetail;
  int selectedLang = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    meetUpDetail = await ref
        .read(meetUpRepositoryProvider)
        .getMeetUpDetail(widget.meetUpId);
    setState(() {
      meetUpDetail = meetUpDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultLayout(
        // TODO: topic에 따라 이미지 다르게
        backgroundImageSrc: 'assets/images/bg_food.png',
        borderShape: false,
        title: '',
        onTapLeading: () {
          Navigator.pop(context);
        },
        shape: const Border(
          bottom: BorderSide(
            color: kColorBorderDefalut,
            width: 1,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/icons/ic_more_horiz_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // section 1
              _InformBox(context, meetUpDetail),

              // section2 모임소개
              _description(context, meetUpDetail),

              // Section3
              _participants(context, meetUpDetail),

              // section4 언어레벨
              Container(
                decoration: const BoxDecoration(color: kColorBgDefault),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "모임 참가자들의 언어 레벨",
                        style: getTsHeading18(context)
                            .copyWith(color: kColorContentDefault),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            itemBuilder: (context, index) => ChipWidget(
                              text: 'text',
                              isSelected: index == selectedLang,
                              selectedColor: kColorBgInverseWeak,
                              selectedBorderColor: kColorBgInverseWeak,
                              selectedTextColor: kColorContentInverse,
                              onClickSelect: () {
                                setState(() {
                                  selectedLang = index;
                                });
                              },
                            ),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 4,
                              );
                            },
                            itemCount: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 20),
                          decoration: const BoxDecoration(
                              color: kColorBgElevation1,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            children: [
                              // TODO: 차트
                              const SizedBox(height: 24),
                              Text(
                                "한국어가 능숙한 사람이 가장 많아요",
                                style: getTsBody16Sb(context)
                                    .copyWith(color: kColorContentWeak),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: kColorBgDefault),
                padding: const EdgeInsets.only(
                    top: 12, bottom: 20, left: 20, right: 20),
                child: const FilledButtonWidget(isEnable: true, text: '참여신청'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Padding _InformBox(BuildContext context, MeetUpDetailModel meetUpDetail) {
  final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
  final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');

  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // title
        Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                ExtendedWrap(
                  spacing: 4,
                  runSpacing: 4,
                  maxLines: 3,
                  children: [
                    ...meetUpDetail.topics.map(
                      (topic) => (BadgeWidget(
                        text: topic.kr_name,
                        backgroundColor: kColorBgInverseWeak,
                        textColor: kColorContentInverse,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  meetUpDetail.name,
                  style: getTsHeading20(context)
                      .copyWith(color: kColorContentDefault),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),

        // infoBox
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 24,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              'assets/icons/ic_calendar_check_fill_24.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeaker,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    dateFormat1.format(
                                      DateTime.parse(meetUpDetail.meeting_time),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '·',
                                    textAlign: TextAlign.center,
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateFormat2.format(
                                      DateTime.parse(meetUpDetail.meeting_time),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              'assets/icons/ic_person_fill_24.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeaker,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      '${meetUpDetail.current_participants}/${meetUpDetail.max_participants}명',
                                      textAlign: TextAlign.center,
                                      style: getTsBody14Rg(context)
                                          .copyWith(color: kColorContentWeak)),
                                  const SizedBox(width: 8),
                                  if (meetUpDetail.participants_status != '')
                                    BadgeWidget(
                                        text: meetUpDetail.participants_status,
                                        textColor: kColorContentSecondary,
                                        backgroundColor: kColorBgSecondaryWeak),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              'assets/icons/ic_language_line_24.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeaker,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ExtendedWrap(
                              spacing: 8,
                              runSpacing: 6,
                              maxLines: 2,
                              children: [
                                ...meetUpDetail.languages.map(
                                  (lang) => (Text(
                                    lang.kr_name,
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // location
        Container(
          decoration: ShapeDecoration(
            color: kColorBgDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_pin_line_24.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeaker,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(meetUpDetail.location),
            ],
          ),
        ),
      ],
    ),
  );
}

Container _description(BuildContext context, MeetUpDetailModel meetUpDetail) {
  return Container(
    decoration: const ShapeDecoration(
      color: kColorBgDefault,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "모임 소개",
            style:
                getTsHeading18(context).copyWith(color: kColorContentDefault),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meetUpDetail.description != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  meetUpDetail.description,
                  style: getTsBody16Rg(context)
                      .copyWith(color: kColorContentWeaker),
                ),
              ),
            if (meetUpDetail.tags.isNotEmpty)
              ExtendedWrap(
                spacing: 6,
                runSpacing: 8,
                maxLines: 2,
                children: [
                  ...meetUpDetail.tags.map((tag) => (BadgeWidget(
                        text: tag.kr_name,
                        backgroundColor: kColorBgElevation1,
                        textColor: kColorContentWeaker,
                      ))),
                ],
              ),
          ],
        )
      ],
    ),
  );
}

Container _participants(BuildContext context, MeetUpDetailModel meetUpDetail) {
  return Container(
    decoration: const BoxDecoration(color: kColorBgDefault),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "참가자 ${meetUpDetail.current_participants}",
            style:
                getTsHeading18(context).copyWith(color: kColorContentDefault),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meetUpDetail.participants_status != '')
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: const BoxDecoration(
                    color: kColorBgElevation1,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_person_fill_24.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        kColorContentPlaceholder,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meetUpDetail.participants_status == '외국인 모집'
                          ? "첫 외국인 참가자가 되어보세요"
                          : "첫 한국인 참가자가 되어보세요",
                      style: getTsBody16Sb(context)
                          .copyWith(color: kColorContentPlaceholder),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 16,
            ),

            // profileList
            ...meetUpDetail.participants.map((participant) => (Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          return AvatarWithFlagWidget(
                            flagPath: participant.user_nationality.isEmpty
                                ? null
                                : '$kS3Url$kS3Flag43Path/${participant.user_nationality[0].nationality.code}.svg',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(participant.name,
                                  style: getTsBody16Sb(context)
                                      .copyWith(color: kColorContentWeak)),
                              const SizedBox(height: 2),
                              Text(
                                "${participant.profile?.user_university.university.kr_name} · ${participant.profile?.user_university.department} ${participant.profile?.user_university.education_status}",
                                style: getTsBody14Rg(context)
                                    .copyWith(color: kColorContentWeaker),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ExtendedWrap(
                            spacing: 4,
                            runSpacing: 4,
                            maxLines: 2,
                            children: [
                              ...participant.profile!.introductions.map(
                                (introduction) => (BadgeWidget(
                                  text: introduction.keyword,
                                  backgroundColor: kColorBgElevation1,
                                  textColor: kColorContentWeaker,
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )))
          ],
        ),
      ],
    ),
  );
}
