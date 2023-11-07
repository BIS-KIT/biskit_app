import 'dart:math';

import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/profile/components/language_card_widget.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/introduction_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  onTapLangCard(UserModel userState) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: kColorBgDefault,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '사용가능언어',
                          style: getTsHeading18(context).copyWith(
                            color: kColorContentDefault,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icons/ic_cancel_line_24.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              kColorContentDefault,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ...userState.profile!.available_languages
                          .map(
                            (l) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: kColorBorderDefalut,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l.language.kr_name,
                                    style: getTsBody16Sb(context).copyWith(
                                      color: kColorContentWeak,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        getLevelServerValueToKrString(l.level),
                                        style: getTsBody16Sb(context).copyWith(
                                          color: kColorContentSecondary,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      LevelBarWidget(
                                        level:
                                            getLevelServerValueToInt(l.level),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTop(context),
          userState is! UserModel
              ? const Expanded(
                  child: CustomLoading(),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ProfileCard
                        _buildProfileCard(userState, context),

                        const SizedBox(
                          height: 28,
                        ),

                        // Tab view area
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: kColorBorderDefalut,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: tabController,
                            padding: EdgeInsets.zero,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: kColorContentDefault,
                            indicatorWeight: 2,
                            labelStyle: getTsHeading18(context),
                            labelColor: kColorContentDefault,
                            unselectedLabelStyle: getTsHeading18(context),
                            unselectedLabelColor: kColorContentWeakest,
                            indicatorPadding: EdgeInsets.zero,
                            splashFactory: NoSplash.splashFactory,
                            labelPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            onTap: (value) {
                              setState(() {});
                            },
                            tabs: const [
                              Tab(
                                height: 25,
                                text: '내 모임',
                              ),
                              Tab(
                                height: 25,
                                text: '후기',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),

                        Builder(
                          builder: (context) {
                            if (tabController.index == 0) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Column(
                                  children: [
                                    // Status tab
                                    Row(
                                      children: [
                                        ChipWidget(
                                          text: '참여중',
                                          textColor: kColorContentInverse,
                                          isSelected: true,
                                          selectedColor: kColorBgInverseWeak,
                                          selectedBorderColor:
                                              kColorBgInverseWeak,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        ChipWidget(
                                          text: '승인대기',
                                          isSelected: false,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        ChipWidget(
                                          text: '지난모임',
                                          isSelected: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else if (tabController.index == 1) {
                              return Container(
                                child: const Text('2'),
                              );
                            } else if (tabController.index == 2) {
                              return Container(
                                child: const Text('3'),
                              );
                            }
                            return Container();
                          },
                        ),

                        // SizedBox(
                        //   height: 600,
                        //   child: TabBarView(
                        //     controller: tabController,
                        //     children: const [
                        //       Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Text('1'),
                        //         ],
                        //       ),
                        //       Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Text('2'),
                        //         ],
                        //       ),
                        //       Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Text('3'),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Padding _buildProfileCard(UserModel userState, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: kColorBgDefault,
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
            // Profile and Language
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: kColorBgElevation1,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AvatarWithFlagWidget(
                        radius: 32,
                        flagRadius: 20,
                        profilePath: userState.profile!.profile_photo,
                        flagPath: userState.user_nationality.isEmpty
                            ? null
                            : '$kS3Url$kS3Flag43Path/${userState.user_nationality[0].nationality.code}.svg',
                      ),

                      // Language card
                      GestureDetector(
                        onTap: () {
                          onTapLangCard(userState);
                        },
                        child: LanguageCardWidget(
                          langList: userState.profile!.available_languages,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Name area
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name and gender
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userState.name,
                              style: getTsHeading20(context).copyWith(
                                color: kColorContentDefault,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: kColorBgElevation2,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: SvgPicture.asset(
                              userState.gender == 'female'
                                  ? 'assets/icons/ic_female_line_24.svg'
                                  : 'assets/icons/ic_male_line_24.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                kColorContentWeaker,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // SubText area
                      Wrap(
                        spacing: 4,
                        children: [
                          Text(
                            userState.user_university[0].university.kr_name,
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeaker,
                            ),
                          ),
                          Text(
                            '·',
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeakest,
                            ),
                          ),
                          Text(
                            '${userState.user_university[0].department} ${userState.user_university[0].education_status}',
                            style: getTsBody14Rg(context).copyWith(
                              color: kColorContentWeaker,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Badge group
            GestureDetector(
              // behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntroductionViewScreen(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: [
                          // Badge
                          ...userState.profile!.introductions
                              .map(
                                (e) => BadgeWidget(text: e.keyword),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Transform.rotate(
                      angle: -90 * pi / 180,
                      child: SvgPicture.asset(
                        'assets/icons/ic_chevron_down_line_24.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          kColorContentWeakest,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // btn
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                bottom: 20,
                right: 20,
              ),
              child: OutlinedButtonWidget(
                text: '프로필 수정',
                height: 40,
                isEnable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
        top: 2,
        bottom: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'MY',
            style: getTsHeading20(context).copyWith(
              color: kColorContentDefault,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/ic_notifications_line_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/ic_settings_line_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
