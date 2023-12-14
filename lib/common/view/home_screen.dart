import 'package:biskit_app/common/components/btn_tag_widget.dart';
import 'package:biskit_app/common/components/category_item_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/provider/home_provider.dart';
import 'package:biskit_app/common/provider/root_provider.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/components/schedule_card_widget.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/meet_up_filter_provider.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/meet/view/meet_up_search_screen.dart';
import 'package:biskit_app/setting/view/alarm_list_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Color _color = kColorBgPrimary;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController.offset >= 270) {
      if (_color != kColorBgElevation1) {
        setState(() {
          _color = kColorBgElevation1;
        });
      }
    } else {
      if (_color != kColorBgPrimary) {
        setState(() {
          _color = kColorBgPrimary;
        });
      }
    }
  }

  void onTapCategory(TopicModel topicModel) {
    ref.read(rootProvider.notifier).onTapBottomNav(index: 1);
    ref.read(meetUpFilterProvider.notifier).onTapTopicAndTag(
          type: MeetUpFilterType.topic,
          id: topicModel.id,
        );
  }

  void onTapTag(TagModel tagModel) {
    ref.read(rootProvider.notifier).onTapBottomNav(index: 1);
    ref.read(meetUpFilterProvider.notifier).onTapTopicAndTag(
          type: MeetUpFilterType.tag,
          id: tagModel.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final padding = MediaQuery.of(context).padding;

    final userState = ref.watch(userMeProvider);
    final homeState = ref.watch(homeProvider);

    return SafeArea(
      top: false,
      bottom: false,
      child: homeState.approveMeetings.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Navigation bar
                _buildNavigatorBar(
                  isApproveMeetupEmpty: true,
                ),
                if (userState is UserModel)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          // Category
                          _buildCategory(
                            userState,
                            context,
                            homeState,
                            true,
                          ),

                          Container(
                            color: kColorBgElevation1,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                // Meetup
                                if (homeState.meetings.isNotEmpty)
                                  _buildMeetupList(
                                    context,
                                    homeState,
                                    size,
                                  ),

                                // Tag
                                _buildTag(
                                  context,
                                  homeState,
                                ),

                                const SizedBox(
                                  height: 36,
                                ),

                                // Make meetup card
                                _buildMakeMeetupCard(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Navigation bar
                _buildNavigatorBar(
                  isApproveMeetupEmpty: false,
                  color: _color,
                ),
                if (userState is UserModel)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          // Schedule
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 280,
                                    color: kColorBgPrimary,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    color: kColorBgElevation1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(
                                          height: 73,
                                        ),
                                        // Category
                                        _buildCategory(
                                          userState,
                                          context,
                                          homeState,
                                          false,
                                        ),

                                        const SizedBox(
                                          height: 36,
                                        ),
                                        // Meetup
                                        if (homeState.meetings.isNotEmpty)
                                          _buildMeetupList(
                                            context,
                                            homeState,
                                            size,
                                          ),

                                        // Tag
                                        _buildTag(
                                          context,
                                          homeState,
                                        ),

                                        const SizedBox(
                                          height: 36,
                                        ),

                                        // Make meetup card
                                        _buildMakeMeetupCard(context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // title
                                    _buildApproveTitle(
                                      userState,
                                      context,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),

                                    // Card area
                                    _buildApproveCardArea(
                                      homeState,
                                      size,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  SizedBox _buildApproveCardArea(HomeState homeState, Size size) {
    return SizedBox(
      height: 249,
      child: homeState.approveMeetings.length == 1
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ScheduleCardWidget(
                meetUpModel: homeState.approveMeetings[0],
                width: size.width - 40,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ScheduleCardWidget(
                meetUpModel: homeState.approveMeetings[index],
                width: size.width - 80,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 12,
              ),
              itemCount: homeState.approveMeetings.length,
            ),
    );
  }

  Padding _buildApproveTitle(UserModel userState, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Text(
              '${userState.profile!.nick_name}님\n다가오는 모임이 있어요',
              style: getTsHeading20(context).copyWith(
                color: kColorContentOnBgPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/ic_chevron_right_line_24.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMakeMeetupCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Text(
            '원하는 모임이 없다면 직접 만들어볼까요?',
            style: getTsBody14Sb(context).copyWith(
              color: kColorContentWeaker,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                createUpDownRoute(
                  const MeetUpCreateScreen(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButtonWidget(
                  text: '모임 만들기',
                  isEnable: true,
                  height: 44,
                  leftIconPath: 'assets/icons/ic_plus_line_24.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildTag(BuildContext context, HomeState homeState) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              '태그로 찾기',
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...homeState.tags
                  .map(
                    (t) => GestureDetector(
                      onTap: () {
                        onTapTag(t);
                      },
                      child: BtnTagWidget(
                        label: t.kr_name.isNotEmpty ? t.kr_name : t.en_name,
                        emoji: '',
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildMeetupList(
      BuildContext context, HomeState homeState, Size size) {
    return SizedBox(
      height: 230 + 36,
      child: Column(
        children: [
          // Title area
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '우리학교에서 개설된 모임',
                    style: getTsHeading18(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: SvgPicture.asset(
                    'assets/icons/ic_chevron_right_line_24.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kColorContentWeakest,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          SizedBox(
            height: 186,
            child: homeState.meetings.length == 1
                ? MeetUpCardWidget(
                    model: homeState.meetings[0],
                    userModel: ref.watch(userMeProvider),
                    sizeType: MeetUpCardSizeType.M,
                    width: size.width - 40,
                    onTapMeetUp: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetUpDetailScreen(
                            meetUpModel: homeState.meetings[0],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => MeetUpCardWidget(
                      model: homeState.meetings[index],
                      userModel: ref.watch(userMeProvider),
                      sizeType: MeetUpCardSizeType.M,
                      width: size.width - 80,
                      onTapMeetUp: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetUpDetailScreen(
                              meetUpModel: homeState.meetings[index],
                            ),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 12,
                    ),
                    itemCount: homeState.meetings.length,
                  ),
          ),
          const SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(UserModel userState, BuildContext context,
      HomeState homeState, bool isApproveEmpty) {
    return isApproveEmpty
        ? Container(
            color: kColorBgDefault,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              // horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${userState.profile!.nick_name}님\n새로운 모임을 찾아볼까요?',
                    style: getTsHeading20(context).copyWith(
                      color: kColorContentOnBgPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 16,
                  children: [
                    ...homeState.fixTopics
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              onTapCategory(e);
                            },
                            child: CategoryItemWidget(
                              iconPath: e.icon_url,
                              text: e.kr_name,
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            ),
          )
        : Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 16,
            children: [
              ...homeState.fixTopics
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        onTapCategory(e);
                      },
                      child: CategoryItemWidget(
                        iconPath: e.icon_url,
                        text: e.kr_name,
                      ),
                    ),
                  )
                  .toList(),
            ],
          );
  }

  Widget _buildNavigatorBar({
    required bool isApproveMeetupEmpty,
    Color? color,
  }) {
    final padding = MediaQuery.of(context).padding;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(top: padding.top),
      color: isApproveMeetupEmpty ? kColorBgDefault : color,
      height: 48 + padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: SvgPicture.asset(
              'assets/icons/biskit_signature_mono.svg',
              width: 57,
              height: 26,
              colorFilter: ColorFilter.mode(
                isApproveMeetupEmpty
                    ? kColorContentWeaker
                    : kColorContentOnBgPrimary,
                BlendMode.srcIn,
              ),
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
                      builder: (context) => const MeetUpSearchScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/icons/ic_search_line_24.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      kColorContentDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
