import 'dart:io';

import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/provider/home_provider.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_view_screen.dart';
import 'package:biskit_app/setting/view/report_screen.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/components/badge_emoji_widget.dart';
import 'package:biskit_app/common/components/badge_widget.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/number_badge_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/meet/view/meet_up_member_management_screen.dart';
import 'package:biskit_app/profile/components/profile_list_with_subtext_widget.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/profile/model/language_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetUpDetailScreen extends ConsumerStatefulWidget {
  final MeetUpModel meetUpModel;
  const MeetUpDetailScreen({
    Key? key,
    required this.meetUpModel,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpDetailScreen> createState() => _MeetUpDetailScreenState();
}

class ChartDataListModel {
  LanguageModel lang;
  List<ChartDataModel> dataList;
  ChartDataListModel({
    required this.lang,
    required this.dataList,
  });
}

class ChartDataModel {
  final String title;
  final int value;
  ChartDataModel({
    required this.title,
    required this.value,
  });
}

class _MeetUpDetailScreenState extends ConsumerState<MeetUpDetailScreen> {
  final GlobalKey _mainBoxKey = GlobalKey();
  final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
  final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');

  UserModel? userState;
  MeetUpDetailModel? meetUpDetailModel;
  List<AvailableLanguageModel> availableLangList = [];
  // Set<LanguageModel> langSet = <LanguageModel>{};
  final ScrollController scrollController = ScrollController();
  bool isTitleView = false;

  double opacity = 0;

  int chartLangSelectedIndex = 0;
  int chartTouchedIndex = 0;
  List<ChartDataListModel> chartDatas = [];

  String? participationStatus;

  @override
  void initState() {
    init();
    scrollController.addListener(() {
      // logger.d(scrollController.offset);
      Size? mainBoxSize = getWidgetSize(_mainBoxKey);
      if (mainBoxSize != null && scrollController.offset < mainBoxSize.height) {
        double tempOpacity =
            scrollController.offset / (mainBoxSize.height - 100);
        if (tempOpacity >= 0.9) {
          opacity = 1;
        } else if (tempOpacity < 0.1) {
          opacity = 0;
        } else {
          opacity = tempOpacity;
        }
        setState(() {});
      }
    });
    super.initState();
  }

  init() async {
    meetUpDetailModel = await ref
        .read(meetUpRepositoryProvider)
        .getMeetUpDetail(widget.meetUpModel.id);

    for (var u in meetUpDetailModel!.participants) {
      availableLangList.addAll(u.profile!.available_languages);
    }
    // for (var lang in availableLangList) {
    //   langSet.add(lang.language);
    // }
    getParticipationStatus();
    setChartDatas();
    setState(() {});
  }

  // 참여자 신청 상태 가져오기
  void getParticipationStatus() async {
    UserModelBase? user = ref.watch(userMeProvider);
    if (user is UserModel) {
      participationStatus =
          await ref.read(meetUpRepositoryProvider).getCheckMeetingRequestStatus(
                meeting_id: widget.meetUpModel.id,
                user_id: user.id,
              );
      // logger.d(participationStatus);
      setState(() {});
    }
  }

  setChartDatas() {
    for (var l in meetUpDetailModel!.languages) {
      List<ChartDataModel> list = [];

      Set<String> levelSet = availableLangList
          .where((element) => element.language.id == l.id)
          .map((e) => e.level)
          .toSet();
      for (var level in levelSet) {
        list.add(ChartDataModel(
          title: getLevelServerValueToKrString(level),
          value: availableLangList
              .where((element) =>
                  element.language.id == l.id && element.level == level)
              .length,
        ));
      }
      chartDatas.add(ChartDataListModel(
        lang: l,
        dataList: list,
      ));
    }
  }

  // 모임원 관리
  onTapMembersManagement() async {
    if (meetUpDetailModel == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetUpMemberManagementScreen(
          meetUpDetailModel: meetUpDetailModel!,
        ),
      ),
    );
    await init();
  }

  // 참여신청
  onTapJoin() async {
    showConfirmModal(
      context: context,
      title: '참여하시겠어요?',
      leftButton: '취소',
      leftCall: () {
        Navigator.pop(context);
      },
      rightButton: '참여신청',
      rightBackgroundColor: kColorBgPrimary,
      rightTextColor: kColorContentOnBgPrimary,
      rightCall: () async {
        final bool isOk =
            await ref.read(meetUpRepositoryProvider).postJoinRequest(
                  meeting_id: widget.meetUpModel.id,
                  user_id: userState!.id,
                );
        if (isOk) {
          init();
        }
        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }

  // 프로필 선택
  onTapProfile(UserModel userModel) {
    if (userModel.profile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileViewScreen(userId: userModel.id),
      ),
    );
  }

  // 채팅하기 버튼
  onTapChatting() async {
    if (meetUpDetailModel == null || userState == null) return;
    await ref.read(chatRepositoryProvider).goChatRoom(
          chatRoomUid: meetUpDetailModel!.chat_id,
          user: userState!,
        );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatRoomUid: meetUpDetailModel!.chat_id,
        ),
      ),
    );
  }

  onTapMore() {
    if (userState!.id == widget.meetUpModel.creator.id) {
      // 모임장
      showMoreBottomSheet(
        context: context,
        list: [
          MoreButton(
            text: '수정하기',
            color: kColorContentDefault,
            onTap: () async {
              if (meetUpDetailModel == null) return;

              ref
                  .read(createMeetUpProvider.notifier)
                  .setCreateMeeupModel(CreateMeetUpModel(
                    custom_tags: meetUpDetailModel!.tags
                        .where((element) => element.is_custom)
                        .map(
                            (e) => e.kr_name.isNotEmpty ? e.kr_name : e.en_name)
                        .toList(),
                    custom_topics: meetUpDetailModel!.topics
                        .where((element) => element.is_custom)
                        .map(
                            (e) => e.kr_name.isNotEmpty ? e.kr_name : e.en_name)
                        .toList(),
                    creator_id: meetUpDetailModel!.creator.id,
                    tag_ids: meetUpDetailModel!.tags
                        .where((element) => !element.is_custom)
                        .map((e) => e.id)
                        .toList(),
                    topic_ids: meetUpDetailModel!.topics
                        .where((element) => !element.is_custom)
                        .map((e) => e.id)
                        .toList(),
                    language_ids:
                        meetUpDetailModel!.languages.map((e) => e.id).toList(),
                    location: meetUpDetailModel!.location,
                    max_participants: meetUpDetailModel!.max_participants,
                    meeting_time: meetUpDetailModel!.meeting_time,
                    name: meetUpDetailModel!.name,
                    description: meetUpDetailModel!.description,
                    x_coord: meetUpDetailModel!.x_coord,
                    y_coord: meetUpDetailModel!.y_coord,
                    place_url: meetUpDetailModel!.place_url,
                    chat_id: meetUpDetailModel!.chat_id,
                    image_url: meetUpDetailModel!.image_url,
                    is_active: meetUpDetailModel!.is_active,
                  ));
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetUpCreateScreen(
                    isEditMode: true,
                    editMeetingId: meetUpDetailModel!.id,
                  ),
                ),
              );
              if (result) {
                await init();
              }
            },
          ),
          MoreButton(
            text: '삭제하기',
            color: kColorContentError,
            onTap: () async {
              Navigator.pop(context);
              showConfirmModal(
                context: context,
                title: '모임을 삭제하시겠어요?',
                content: '모임 삭제시 채팅방이\n함께 삭제되며 복구할 수 없어요',
                leftButton: '취소',
                leftCall: () {
                  Navigator.pop(context);
                },
                rightButton: '삭제',
                rightBackgroundColor: kColorBgError,
                rightTextColor: kColorContentError,
                rightCall: () async {
                  if (meetUpDetailModel != null) {
                    final bool isOk = await ref
                        .read(meetUpRepositoryProvider)
                        .deleteMeeting(meetUpDetailModel!);
                    if (!mounted) return;
                    if (isOk) {
                      ref.read(homeProvider.notifier).init();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                },
              );
            },
          ),
        ],
      );
    } else if (meetUpDetailModel!.participants
        .any((element) => element.id == userState!.id)) {
      // 참여자
      showMoreBottomSheet(
        context: context,
        list: [
          MoreButton(
            text: '모임 나가기',
            color: kColorContentError,
            onTap: () async {
              bool isOk =
                  await ref.read(meetUpRepositoryProvider).postExitMeeting(
                        user_id: userState!.id,
                        meeting_id: meetUpDetailModel!.id,
                      );
              if (isOk) {
                await init();
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
          ),
          MoreButton(
            text: '신고하기',
            color: kColorContentError,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(
                    contentType: ReportContentType.Meeting,
                    contentId: widget.meetUpModel.id,
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      // 비참가인
      showMoreBottomSheet(
        context: context,
        list: [
          MoreButton(
            text: '신고하기',
            color: kColorContentError,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(
                    contentType: ReportContentType.Meeting,
                    contentId: widget.meetUpModel.id,
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userMeProvider) as UserModel;
    // final size = MediaQuery.of(context).size;
    final paddig = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: kColorBgDefault,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Builder(builder: (context) {
                              String bgImagePath = 'assets/images/bg_food.png';
                              if (meetUpDetailModel != null) {
                                if ((meetUpDetailModel!.image_url)
                                    .contains('activity')) {
                                  bgImagePath = 'assets/images/bg_activity.png';
                                } else if ((meetUpDetailModel!.image_url)
                                    .contains('study')) {
                                  bgImagePath = 'assets/images/bg_study.png';
                                } else if ((meetUpDetailModel!.image_url)
                                    .contains('sports')) {
                                  bgImagePath = 'assets/images/bg_sports.png';
                                } else if ((meetUpDetailModel!.image_url)
                                    .contains('lang')) {
                                  bgImagePath = 'assets/images/bg_lang.png';
                                } else if ((meetUpDetailModel!.image_url)
                                    .contains('culture')) {
                                  bgImagePath = 'assets/images/bg_culture.png';
                                } else if ((meetUpDetailModel!.image_url)
                                    .contains('hobby')) {
                                  bgImagePath = 'assets/images/bg_hobby.png';
                                } else {
                                  bgImagePath = 'assets/images/bg_talk.png';
                                }
                              }
                              return Container(
                                key: _mainBoxKey,
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 32,
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      bgImagePath,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 48 + 24 + paddig.top,
                                    ),
                                    if (meetUpDetailModel != null)
                                      ExtendedWrap(
                                        spacing: 4,
                                        maxLines: 1,
                                        children: [
                                          ...meetUpDetailModel!.topics.map(
                                            (topic) => BadgeWidget(
                                              text: topic.kr_name,
                                              backgroundColor:
                                                  kColorBgInverseWeak,
                                              textColor: kColorContentInverse,
                                              sizeType: BadgeSizeType.L,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      meetUpDetailModel?.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: getTsHeading20(context).copyWith(
                                          color: kColorContentDefault),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),

                                    // infoBox
                                    _buildInfoBox(context),

                                    const SizedBox(
                                      height: 12,
                                    ),

                                    // location
                                    _buildLocation(context),

                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          Container(
                            width: double.infinity,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: kColorBgDefault,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 모임 소개
                          _buildIntroArea(context),

                          // 참가자
                          _buildJoinList(context),

                          // 모임 참가자들의 언어 레벨
                          if (chartDatas.isNotEmpty) _buildChart(context),
                          const SizedBox(
                            height: 26,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 12,
                  left: 20,
                  bottom: Platform.isIOS ? 34 : 20,
                  right: 20,
                ),
                child: _buildBottomButton(),
              ),
            ],
          ),

          // Appbar
          _buildAppBar(paddig, context),
        ],
      ),
    );
  }

  Padding _buildChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "모임 참가자들의 언어 레벨",
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ChipWidget(
                text: chartDatas[index].lang.kr_name,
                isSelected: index == chartLangSelectedIndex,
                selectedColor: kColorBgInverseWeak,
                selectedBorderColor: kColorBgInverseWeak,
                selectedTextColor: kColorContentInverse,
                onClickSelect: () {
                  setState(() {
                    chartLangSelectedIndex = index;
                    chartTouchedIndex = 0;
                  });
                },
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 6,
              ),
              itemCount: chartDatas.length,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: const BoxDecoration(
              color: kColorBgElevation1,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 154,
                  width: 154,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 30,
                      startDegreeOffset: 270,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              // chartTouchedIndex = -1;
                              return;
                            }
                            if (chartTouchedIndex ==
                                pieTouchResponse
                                    .touchedSection!.touchedSectionIndex) {
                              chartTouchedIndex = -1;
                            } else {
                              chartTouchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            }
                          });
                        },
                      ),
                      sectionsSpace: 2,
                      sections: showingSections(),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "한국어가 능숙한 사람이 가장 많아요",
                  style:
                      getTsBody16Sb(context).copyWith(color: kColorContentWeak),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    if (meetUpDetailModel == null) return Container();

    if (meetUpDetailModel!.is_active && userState != null) {
      if (userState!.profile!.student_verification == null) {
        // 학생증 인증 안한 상태
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileIdConfirmScreen(
                  isEditor: true,
                ),
              ),
            );
            await ref.read(userMeProvider.notifier).getMe();
          },
          child: const FilledButtonWidget(
            text: '학교 인증하고 참여하기',
            isEnable: true,
          ),
        );
      } else if (userState!
              .profile!.student_verification!.verification_status ==
          VerificationStatus.PENDING.name) {
        // 학생증 인증 대기 상태
        return const FilledButtonWidget(
          text: '학교 인증 승인 후 참여 가능',
          isEnable: false,
        );
      } else {
        if (userState!.id == meetUpDetailModel!.creator.id) {
          return GestureDetector(
            onTap: () {
              onTapMembersManagement();
            },
            child: const FilledButtonWidget(
              text: '모임원 관리',
              isEnable: true,
            ),
          );
        } else if (meetUpDetailModel!.participants
            .any((element) => element.id == userState!.id)) {
          return GestureDetector(
            onTap: () {
              onTapChatting();
            },
            child: const FilledButtonWidget(
              text: '채팅하기',
              isEnable: true,
            ),
          );
        } else {
          if (participationStatus != null) {
            if (participationStatus == VerificationStatus.PENDING.name) {
              return const FilledButtonWidget(
                text: '참여 수락 대기중',
                isEnable: false,
              );
            } else if (participationStatus == VerificationStatus.PENDING.name) {
              return const FilledButtonWidget(
                text: '참여 수락 대기중',
                isEnable: false,
              );
            }
          }
          return GestureDetector(
            onTap: () {
              onTapJoin();
            },
            child: const FilledButtonWidget(
              text: '참여신청',
              isEnable: true,
              height: 52,
            ),
          );
        }
      }
    } else {
      return const FilledButtonWidget(
        text: '종료된 모임이에요',
        isEnable: false,
        height: 52,
      );
    }
  }

  Container _buildAppBar(EdgeInsets paddig, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2 + paddig.top,
        bottom: 2,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: kColorBgDefault.withOpacity(opacity),
        border: opacity < 0.2
            ? null
            : Border(
                bottom: BorderSide(
                  width: opacity,
                  color: kColorBorderDefalut,
                ),
              ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 44,
              height: 44,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/ic_arrow_back_ios_line_24.svg',
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
            width: 44,
          ),
          Expanded(
            child: Opacity(
              // duration: const Duration(seconds: 1),
              opacity: opacity,
              child: Text(
                meetUpDetailModel?.name ?? '',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: getTsBody16Sb(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 44,
          ),
          GestureDetector(
            onTap: () {
              onTapMore();
            },
            child: Container(
              width: 44,
              height: 44,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/ic_more_horiz_line_24.svg',
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
    );
  }

  Padding _buildJoinList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              children: [
                Text(
                  "참가자",
                  style: getTsHeading18(context)
                      .copyWith(color: kColorContentDefault),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  (meetUpDetailModel?.current_participants ?? '').toString(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (meetUpDetailModel != null &&
              (meetUpDetailModel!.foreign_count == 0 ||
                  meetUpDetailModel!.korean_count == 0))
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                bottom: 24,
                right: 16,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                color: kColorBgElevation1,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 9.57,
                      left: 6.05,
                      bottom: 9.53,
                      right: 6.01,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ic_person_one.svg',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "첫 ${meetUpDetailModel!.foreign_count == 0 ? '외국인' : '한국인'} 참가자가 되어보세요",
                    style: getTsBody16Sb(context)
                        .copyWith(color: kColorContentPlaceholder),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          if (meetUpDetailModel != null)
            // 참가자 리스트
            Column(
              children: [
                ...meetUpDetailModel!.participants.map(
                  (e) => ProfileListWithSubtextWidget(
                    userNationalityModel: e.user_nationality[0],
                    name: e.profile!.nick_name,
                    profilePath: e.profile!.profile_photo,
                    isCreator: e.id == meetUpDetailModel!.creator.id,
                    subText:
                        '${e.profile!.user_university.university.kr_name} · ${e.profile!.user_university.department} ${e.profile!.user_university.education_status}',
                    introductions: e.profile!.introductions,
                    onTap: () {
                      onTapProfile(e);
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildIntroArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "모임 소개",
            style:
                getTsHeading18(context).copyWith(color: kColorContentDefault),
          ),
          if (meetUpDetailModel != null &&
              meetUpDetailModel!.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                meetUpDetailModel!.description,
                style:
                    getTsBody16Rg(context).copyWith(color: kColorContentWeaker),
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          if (meetUpDetailModel != null)
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                ...meetUpDetailModel!.tags.map(
                  (tag) => BadgeEmojiWidget(
                    label: tag.kr_name.isNotEmpty ? tag.kr_name : tag.en_name,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  GestureDetector _buildLocation(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (meetUpDetailModel != null &&
            meetUpDetailModel!.place_url.isNotEmpty) {
          await launchUrl(Uri.parse(meetUpDetailModel!.place_url));
        }
      },
      child: Container(
        decoration: ShapeDecoration(
          color: kColorBgDefault,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
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
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Row(
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                meetUpDetailModel?.location ?? '',
                maxLines: 1,
                style: getTsBody14Rg(context).copyWith(
                  color: kColorContentWeak,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (meetUpDetailModel != null &&
                meetUpDetailModel!.place_url.isNotEmpty)
              SvgPicture.asset(
                'assets/icons/ic_chevron_right_line_24.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeakest,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container _buildInfoBox(BuildContext context) {
    return Container(
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
                          'assets/icons/ic_calendar.svg',
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
                              if (meetUpDetailModel != null)
                                Text(
                                  meetUpDetailModel!.meeting_time.isEmpty
                                      ? ''
                                      : dateFormat1.format(
                                          DateTime.parse(
                                              meetUpDetailModel!.meeting_time),
                                        ),
                                  textAlign: TextAlign.center,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeak,
                                  ),
                                ),
                              const SizedBox(width: 4),
                              Text(
                                '·',
                                textAlign: TextAlign.center,
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeak,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (meetUpDetailModel != null)
                                Text(
                                  meetUpDetailModel!.meeting_time.isEmpty
                                      ? ''
                                      : dateFormat2.format(
                                          DateTime.parse(
                                              meetUpDetailModel!.meeting_time),
                                        ),
                                  textAlign: TextAlign.center,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeak,
                                  ),
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
                      if (meetUpDetailModel != null)
                        Expanded(
                          child: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${meetUpDetailModel!.current_participants}/${meetUpDetailModel!.max_participants}명',
                                  textAlign: TextAlign.center,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeak,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (meetUpDetailModel!
                                    .participants_status.isNotEmpty)
                                  BadgeWidget(
                                    text:
                                        meetUpDetailModel!.participants_status,
                                    textColor: kColorContentSecondary,
                                    backgroundColor: kColorBgSecondaryWeak,
                                    sizeType: BadgeSizeType.M,
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
                          'assets/icons/ic_lang.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            kColorContentWeaker,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (meetUpDetailModel != null)
                        Expanded(
                          child: ExtendedWrap(
                            spacing: 8,
                            runSpacing: 6,
                            maxLines: 2,
                            children: [
                              ...meetUpDetailModel!.languages.mapIndexed(
                                (index, lang) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    NumberBadgeWidget(
                                      number: index + 1,
                                      backgroundColor: kColorBgElevation2,
                                      numberColor: kColorContentWeaker,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      lang.kr_name,
                                      style: getTsBody14Rg(context).copyWith(
                                        color: kColorContentWeak,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  showingSections() {
    List<PieChartSectionData> list = [];
    for (int i = 0;
        i < chartDatas[chartLangSelectedIndex].dataList.length;
        i++) {
      PieChartSectionData pieChartSectionData = PieChartSectionData(
        color: kColorBgElevation2,
        value: chartDatas[chartLangSelectedIndex].dataList[i].value.toDouble(),
        badgeWidget: null,
        showTitle: false,
        radius: 46,
      );
      if (i == chartTouchedIndex) {
        pieChartSectionData = pieChartSectionData.copyWith(
          color: kColorBgSecondary,
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
              color: kColorBgOverlay.withOpacity(0.7),
            ),
            child: Text(
              '${chartDatas[chartLangSelectedIndex].dataList[i].title} ${chartDatas[chartLangSelectedIndex].dataList[i].value}명',
              style: getTsCaption12Rg(context).copyWith(
                color: kColorContentInverse,
              ),
            ),
          ),
        );
      }
      list.add(pieChartSectionData);
    }
    return list;
  }
}
