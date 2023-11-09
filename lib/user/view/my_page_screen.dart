import 'dart:math';

import 'package:biskit_app/common/components/avatar_with_flag_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/review_card_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/view/my_meet_up_list_screen.dart';
import 'package:biskit_app/profile/components/language_card_widget.dart';
import 'package:biskit_app/profile/components/use_language_modal_widget.dart';
import 'package:biskit_app/profile/view/profile_edit_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/view/introduction_view_screen.dart';
import 'package:biskit_app/user/view/setting_screen.dart';
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

  // 후기 작성 권한
  bool isReviewWriteEnable = true;
  List reviewList = [
    {
      'imagePath':
          'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'nationalList': <String>[
        'kr',
        'er',
        'ch',
        'fj',
        'gb',
        'gd',
      ],
    },
    {
      'imagePath':
          'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'nationalList': <String>[
        'kr',
        'er',
      ],
    },
  ];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  onTapLangCard(UserModel userState) {
    showDialog(
      context: context,
      builder: (context) {
        return UseLanguageModalWidget(
          available_languages: userState.profile!.available_languages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    final size = MediaQuery.of(context).size;
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
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 22,
                    ),
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
                                child: Column(
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Status tab
                                    const Row(
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
                                          width: 4,
                                        ),
                                        ChipWidget(
                                          text: '승인대기',
                                          isSelected: false,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        ChipWidget(
                                          text: '지난모임',
                                          isSelected: false,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    SizedBox(
                                      height: 164,
                                      child: Center(
                                        child: Text(
                                          '참여중인 모임이 없어요',
                                          style:
                                              getTsBody14Sb(context).copyWith(
                                            color: kColorContentWeakest,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (isReviewWriteEnable) {
                                if (reviewList.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child:
                                        _buildReviewWriteCard(context: context),
                                  );
                                } else {
                                  double width = (size.width - 40 - 8) / 2;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      runSpacing: 8,
                                      children: [
                                        _buildReviewWriteCard(
                                          context: context,
                                          width: width,
                                        ),
                                        ...reviewList
                                            .map((e) => ReviewCardWidget(
                                                  width: width,
                                                  imagePath: e['imagePath'],
                                                  reviewImgType: ReviewImgType
                                                      .networkImage,
                                                  flagCodeList:
                                                      e['nationalList']
                                                          as List<String>,
                                                  isShowDelete: true,
                                                  isShowFlag: true,
                                                  isShowLock: true,
                                                  isShowLogo: true,
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 164,
                                        child: Center(
                                          child: Text(
                                            '모임에 참여하고 후기를 남겨보세요',
                                            style:
                                                getTsBody14Sb(context).copyWith(
                                              color: kColorContentWeakest,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReviewWriteCard({
    required BuildContext context,
    double? width,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyMeetUpListScreen(),
          ),
        );
      },
      child: Container(
        height: width ?? 164,
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: kColorBgElevation3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_plus_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentWeaker,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '인생샷을 남겨보세요',
              style: getTsBody14Sb(context).copyWith(
                color: kColorContentWeaker,
              ),
            ),
          ],
        ),
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
              behavior: HitTestBehavior.opaque,
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 20,
                right: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(
                        profile: userState.profile!,
                        user_university: [
                          ...userState.user_university,
                        ],
                      ),
                    ),
                  );
                },
                child: const OutlinedButtonWidget(
                  text: '프로필 수정',
                  height: 40,
                  isEnable: true,
                ),
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
              GestureDetector(
                child: Padding(
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    ),
                  );
                },
                child: Padding(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
