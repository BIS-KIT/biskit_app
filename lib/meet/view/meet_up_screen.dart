import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MeetUpScreen extends ConsumerStatefulWidget {
  final MeetUpModel meetUp;
  const MeetUpScreen({
    Key? key,
    required this.meetUp,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpScreen> createState() => _MeetUpScreenState();
}

class _MeetUpScreenState extends ConsumerState<MeetUpScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultLayout(
        borderShape: false,
        backgroundColor: kColorBgElevation2,
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // title
                    Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/icons/ic_restaurant_fill_48.svg',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Text(widget.meetUp.name,
                                style: getTsHeading20(context)
                                    .copyWith(color: kColorContentDefault)),
                            const SizedBox(height: 8),
                            ExtendedWrap(
                              spacing: 4,
                              runSpacing: 4,
                              maxLines: 3,
                              children: [
                                ...widget.meetUp.tags.map((tag) => (BadgeWidget(
                                      text: tag.kr_name,
                                      backgroundColor: kColorBgSecondary,
                                      textColor: kColorContentInverse,
                                    ))),
                              ],
                            )
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('10/16 (목)',
                                                  textAlign: TextAlign.center,
                                                  style: getTsBody14Rg(context)
                                                      .copyWith(
                                                          color:
                                                              kColorContentWeak)),
                                              const SizedBox(width: 4),
                                              Text('·',
                                                  textAlign: TextAlign.center,
                                                  style: getTsBody14Rg(context)
                                                      .copyWith(
                                                          color:
                                                              kColorContentWeak)),
                                              const SizedBox(width: 4),
                                              Text('오후 2:00',
                                                  textAlign: TextAlign.center,
                                                  style: getTsBody14Rg(context)
                                                      .copyWith(
                                                          color:
                                                              kColorContentWeak)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('2/3명',
                                                  textAlign: TextAlign.center,
                                                  style: getTsBody14Rg(context)
                                                      .copyWith(
                                                          color:
                                                              kColorContentWeak)),
                                              const SizedBox(width: 8),
                                              const BadgeWidget(
                                                  text: '외국인 모집',
                                                  textColor:
                                                      kColorContentSecondary,
                                                  backgroundColor:
                                                      kColorBgSecondaryWeak),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            ...[
                                              '한국어',
                                              '영어',
                                              '중국어',
                                              '스페인어',
                                              '러시아어',
                                              '영어',
                                              '중국어',
                                              '스페인어',
                                              '러시아어',
                                            ].map((lang) => (Text(
                                                  lang,
                                                  style: getTsBody14Rg(context)
                                                      .copyWith(
                                                          color:
                                                              kColorContentWeak),
                                                ))),
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
                          const Text("내찜닭 숙대입구역점"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // section2
              Container(
                decoration: const ShapeDecoration(
                  color: kColorBgDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
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
                        style: getTsHeading18(context)
                            .copyWith(color: kColorContentDefault),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "학교 앞에서 맛있는 상세설명 밥 먹어요. 학교 앞에서 맛있는 상세설명 밥 먹어요. 학교 앞에서 맛있는 상세설명 밥 먹어요. 학교 앞에서 맛있는 상세설명 밥 먹어요.학교 앞에서 맛있는 상세설명 밥 먹어요. 학교 앞에서 맛있는 상세설명 밥 먹어요.",
                          style: getTsBody16Rg(context)
                              .copyWith(color: kColorContentWeaker),
                        ),
                        const SizedBox(height: 16),
                        ExtendedWrap(
                          spacing: 6,
                          runSpacing: 8,
                          maxLines: 2,
                          children: [
                            ...widget.meetUp.tags.map((tag) => (BadgeWidget(
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
              ),

              // Section3
              Container(
                decoration: const BoxDecoration(color: kColorBgDefault),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "참가자 3",
                        style: getTsHeading18(context)
                            .copyWith(color: kColorContentDefault),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                "첫 외국인 참가자가 되어보세요",
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: kColorBorderPrimary,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_restaurant_fill_48.svg',
                                      width: 16,
                                      height: 16,
                                      colorFilter: const ColorFilter.mode(
                                        kColorContentSecondary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Container(
                              //   decoration: ShapeDecoration(
                              //     image: const DecorationImage(
                              //       image: NetworkImage(
                              //           "https://i.namu.wiki/i/nKts8yq3gH2atl6dQX7KHkSCS6o9jic4dRpxvJmfv7yuBTOMtVKbb0o_LqYoFh_ZqKVI89SE5wk4elbPT50nkA.webp"),
                              //       fit: BoxFit.fill,
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(88),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("바삭한비스킷",
                                          style: getTsBody16Sb(context)
                                              .copyWith(
                                                  color: kColorContentWeak)),
                                      const SizedBox(height: 2),
                                      Text(
                                        "한국대학교 · 학부 재학",
                                        style: getTsBody14Rg(context).copyWith(
                                            color: kColorContentWeaker),
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
                                      ...widget.meetUp.tags.map(
                                        (tag) => (BadgeWidget(
                                          text: tag.kr_name,
                                          backgroundColor: kColorBgElevation1,
                                          textColor: kColorContentWeaker,
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
