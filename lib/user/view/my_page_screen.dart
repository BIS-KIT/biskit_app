import 'package:biskit_app/alarm/model/alarm_list_model.dart';
import 'package:biskit_app/alarm/model/alarm_model.dart';
import 'package:biskit_app/alarm/provider/alarm_provider.dart';
import 'package:biskit_app/alarm/view/alarm_list_screen.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/profile/components/profile_card_widget.dart';
import 'package:biskit_app/profile/provider/profile_meeting_provider.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/components/review_write_card_widget.dart';
import 'package:biskit_app/review/provider/review_provider.dart';
import 'package:biskit_app/review/view/review_view_screen.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/setting/view/setting_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
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

  final ScrollController scrollController = ScrollController();

  // 후기 작성 권한
  bool isReviewWriteEnable = true;

  UserModelBase? userState;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >
              scrollController.position.maxScrollExtent - 300 &&
          tabController.index == 1) {
        if (userState != null && userState is UserModel) {
          ref
              .read(reviewProvider((userState as UserModel).id).notifier)
              .fetchItems();
        }
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // onTapLangCard(UserModel userState) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return UseLanguageModalWidget(
  //         available_languages: userState.profile!.available_languages,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userMeProvider);
    final profileMeetingState = ref.watch(profileMeetingProvider);
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
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ProfileCard
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ProfileCardWidget(
                            userState: userState as UserModel,
                            isMe: true,
                          ),
                        ),

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
                              if (value == 1) {
                                ref
                                    .read(reviewProvider(
                                            (userState as UserModel).id)
                                        .notifier)
                                    .fetchItems(
                                      forceRefetch: true,
                                    );
                              }
                              setState(() {});
                              // ref.read(reviewProvider.notifier).fetchItems();
                            },
                            tabs: [
                              Tab(
                                height: 25,
                                text: 'myPageScreen.tap.myMeetup.title'.tr(),
                              ),
                              Tab(
                                height: 25,
                                text: 'myPageScreen.tap.review.title'.tr(),
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
                              return _buildMeetings(
                                userState as UserModel,
                                profileMeetingState,
                                context,
                              );
                            } else {
                              return _buildReview(
                                  size, (userState as UserModel).id);
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

  Widget _buildReview(Size size, int userId) {
    final reviewState = ref.watch(reviewProvider(userId));
    if (isReviewWriteEnable) {
      if (reviewState.data.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ReviewWriteCardWidget(),
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
              ReviewWriteCardWidget(width: width),
              ...reviewState.data
                  .map((e) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewViewScreen(
                                model: e,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: '$kReviewTagName/${e.id}',
                          child: ReviewCardWidget(
                            width: width,
                            imagePath: e.image_url,
                            reviewImgType: ReviewImgType.networkImage,
                            flagCodeList: e.creator.user_nationality
                                .map((e) => e.nationality.code)
                                .toList(),
                            isShowDelete: false,
                            isShowFlag: true,
                            isShowLock: false,
                            isShowLogo: false,
                          ),
                        ),
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
                  style: getTsBody14Sb(context).copyWith(
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

  Container _buildMeetings(
    UserModel userState,
    ProfileMeetingState profileMeetingState,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          // Status tab
          Row(
            children: [
              _buildChip(
                text: 'myPageScreen.tap.myMeetup.joining'.tr(),
                profileMeetingState: profileMeetingState,
                status: ProfileMeetingStatus.APPROVE,
              ),
              const SizedBox(
                width: 4,
              ),
              _buildChip(
                text: 'myPageScreen.tap.myMeetup.pending'.tr(),
                profileMeetingState: profileMeetingState,
                status: ProfileMeetingStatus.PENDING,
              ),
              const SizedBox(
                width: 4,
              ),
              _buildChip(
                text: 'myPageScreen.tap.myMeetup.past'.tr(),
                profileMeetingState: profileMeetingState,
                status: ProfileMeetingStatus.PAST,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          profileMeetingState.isLoading
              ? const SizedBox(
                  height: 164,
                  child: Center(
                    child: CustomLoading(),
                  ),
                )
              : profileMeetingState.dataList.isEmpty
                  ? SizedBox(
                      height: 164,
                      child: Center(
                        child: Text(
                          _getEmptyText(
                              profileMeetingState.profileMeetingStatus),
                          style: getTsBody14Sb(context).copyWith(
                            color: kColorContentWeakest,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        ...profileMeetingState.dataList
                            .mapIndexed((index, e) => Column(
                                  children: [
                                    MeetUpCardWidget(
                                      model: e,
                                      userModel: userState,
                                      systemModel: ref.watch(systemProvider),
                                      isHostTag: userState.id == e.creator.id,
                                      isParticipantsStatusTag: false,
                                      onTapMeetUp: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MeetUpDetailScreen(
                                              meetUpModel: e,
                                              userModel: userState,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (index !=
                                        profileMeetingState.dataList.length - 1)
                                      const SizedBox(
                                        height: 16,
                                      ),
                                  ],
                                ))
                            .toList(),
                      ],
                    ),
        ],
      ),
    );
  }

  String _getEmptyText(ProfileMeetingStatus status) {
    String str = '';
    if (status == ProfileMeetingStatus.APPROVE) {
      str = 'myPageScreen.tap.myMeetup.noJoiningMeetups'.tr();
    } else if (status == ProfileMeetingStatus.PENDING) {
      str = 'myPageScreen.tap.myMeetup.noPendingMeetups'.tr();
    } else {
      str = 'myPageScreen.tap.myMeetup.noPastMeetups'.tr();
    }
    return str;
  }

  Widget _buildChip({
    required String text,
    required ProfileMeetingState profileMeetingState,
    required ProfileMeetingStatus status,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(profileMeetingProvider.notifier).onTapStatus(status);
      },
      child: ChipWidget(
        text: text,
        textColor: profileMeetingState.profileMeetingStatus == status
            ? kColorContentInverse
            : null,
        selectedTextColor: kColorContentInverse,
        isSelected: profileMeetingState.profileMeetingStatus == status,
        selectedColor: profileMeetingState.profileMeetingStatus == status
            ? kColorBgInverseWeak
            : null,
        selectedBorderColor: profileMeetingState.profileMeetingStatus == status
            ? kColorBgInverseWeak
            : null,
      ),
    );
  }

  Padding _buildTop(BuildContext context) {
    bool hasUnreadAlarm() {
      if (ref.watch(alarmProvider) is AlarmListModel) {
        List<AlarmModel> alarms =
            (ref.watch(alarmProvider) as AlarmListModel).alarms;
        for (var alarm in alarms) {
          if (alarm.is_read == false) {
            return true;
          }
        }
      }
      return false;
    }

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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlarmListScreen(),
                    ),
                  );
                },
                child: Stack(
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
                    if (hasUnreadAlarm() == true)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: kColorBgNotification,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
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
