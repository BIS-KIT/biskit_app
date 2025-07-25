import 'dart:io';

import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/components/badge_emoji_widget.dart';
import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/new_badge_widget.dart';
import 'package:biskit_app/common/components/number_badge_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/provider/home_provider.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/create_meet_up_model.dart';
import 'package:biskit_app/meet/model/meet_up_detail_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/meet/view/meet_up_create_screen.dart';
import 'package:biskit_app/meet/view/meet_up_member_management_screen.dart';
import 'package:biskit_app/profile/components/profile_list_with_subtext_widget.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/profile/model/language_model.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:biskit_app/profile/view/profile_view_screen.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/setting/view/report_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetUpDetailScreen extends ConsumerStatefulWidget {
  final int meetupId;
  final UserModelBase? userModel;

  const MeetUpDetailScreen({
    Key? key,
    required this.meetupId,
    required this.userModel,
  }) : super(key: key);

  @override
  ConsumerState<MeetUpDetailScreen> createState() => _MeetUpDetailScreenState();
}

class ChartDataListModel {
  LanguageModel lang;
  List<ChartDataModel> dataList;
  String description;
  ChartDataListModel({
    required this.lang,
    required this.dataList,
    required this.description,
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
  final DateFormat dateFormatUS = DateFormat('MM/dd (EEE)', 'en_US');
  final DateFormat dateFormatKO = DateFormat('MM/dd (EEE)', 'ko_KR');
  final DateFormat timeFormatUS = DateFormat('a h:mm', 'en_US');
  final DateFormat timeFormatKO = DateFormat('a h:mm', 'ko_KR');

  UserModel? userState;
  UserSystemModelBase? systemState;
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
        .getMeetUpDetail(widget.meetupId);
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
                meeting_id: widget.meetupId,
                user_id: user.id,
              );
      // logger.d(participationStatus);
      setState(() {});
    }
  }

  setChartDatas() {
    // XXX: 모임상세-참가자 사용언어를 기존에는 모임에서 사용할 언어만 filtering 하여 보여줬는데, 모임 참여자들의 언어는 모두 노출시키도록 수정
    for (var l in availableLangList) {
      // for (var l in meetUpDetailModel!.languages) {
      List<ChartDataModel> list = [];
      String description = '';
      Set<String> levelSet = availableLangList
          .where((element) => element.language.id == l.language.id)
          .map((e) => e.level)
          .toSet();

      for (var level in levelSet) {
        list.add(ChartDataModel(
          title: getLevelServerValueToKrString(level),
          value: availableLangList
              .where((element) =>
                  element.language.id == l.language.id &&
                  element.level == level)
              .length,
        ));
      }
      // 챠트 설명 셋팅
      if (list.length == 1) {
        // 레벨이 1개인 경우
        description = getLanMaxDescription(list[0].title);
      } else {
        // 레벨이 1개 이상인 경우

        bool isAllLevelEqual = list.map((e) => e.value).toList().length != 1 &&
            list.map((e) => e.value).toList().toSet().length == 1;

        if (isAllLevelEqual) {
          // 모든 레벨이 같은 경우
          description = 'meetupDetailScreen.langLevel.mixed'.tr();
        } else {
          ChartDataModel chartDataModel = list.reduce((a, b) {
            if (a.value > b.value) {
              return a;
            } else {
              return b;
            }
          });

          description = getLanMaxDescription(chartDataModel.title);
        }
      }
      // TODO: 리팩터링 필요
      if ((chartDatas.map((e) => e.lang.id)).contains(l.language.id)) {
        // return;
      } else {
        chartDatas.add(ChartDataListModel(
          lang: l.language,
          dataList: list,
          description: description,
        ));
      }
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
      title: 'meetupDetailScreen.modal.requestModal.title'.tr(),
      leftButton: 'meetupDetailScreen.modal.requestModal.cancel'.tr(),
      leftCall: () {
        Navigator.pop(context);
      },
      rightButton: 'meetupDetailScreen.modal.requestModal.join'.tr(),
      rightBackgroundColor: kColorBgPrimary,
      rightTextColor: kColorContentOnBgPrimary,
      rightCall: () async {
        context.loaderOverlay.show();

        final bool isOk =
            await ref.read(meetUpRepositoryProvider).postJoinRequest(
                  meeting_id: widget.meetupId,
                  user_id: userState!.id,
                );
        if (isOk) {
          init();
        }

        if (!mounted) return;
        context.loaderOverlay.hide();
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
    if (userState!.id == meetUpDetailModel!.creator.id) {
      // 모임장
      showMoreBottomSheet(
        context: context,
        list: [
          MoreButton(
            text: 'meetupDetailScreen.actionSheet.edit'.tr(),
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
            text: 'meetupDetailScreen.actionSheet.delete'.tr(),
            color: kColorContentError,
            onTap: () async {
              Navigator.pop(context);
              showConfirmModal(
                context: context,
                title: 'meetupDetailScreen.modal.deleteModal.title'.tr(),
                content: 'meetupDetailScreen.modal.deleteModal.subtitle'.tr(),
                leftButton: 'meetupDetailScreen.modal.deleteModal.cancel'.tr(),
                leftCall: () {
                  Navigator.pop(context);
                },
                rightButton: 'meetupDetailScreen.modal.deleteModal.delete'.tr(),
                rightBackgroundColor: kColorBgError,
                rightTextColor: kColorContentError,
                rightCall: () async {
                  bool chatDeleteIsOk = false;
                  if (meetUpDetailModel != null) {
                    context.loaderOverlay.show();

                    final bool isOk = await ref
                        .read(meetUpRepositoryProvider)
                        .deleteMeeting(meetUpDetailModel!);
                    if (isOk) {
                      chatDeleteIsOk = await ref
                          .read(chatRepositoryProvider)
                          .deleteChatRoom(
                              chatRoomUid: meetUpDetailModel!.chat_id);
                    }
                    if (!mounted) return;
                    context.loaderOverlay.hide();

                    if (isOk && chatDeleteIsOk) {
                      ref.read(homeProvider.notifier).init();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      // TODO: 에러 처리 추가 (토스트?)
                      logger.d('모임 삭제 실패');
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
            text: 'meetupDetailScreen.actionSheet.leave'.tr(),
            color: kColorContentError,
            onTap: () async {
              await showConfirmModal(
                context: context,
                leftCall: () {
                  Navigator.pop(context);
                },
                leftButton: 'meetupDetailScreen.modal.leaveModal.cancel'.tr(),
                rightCall: () async {
                  context.loaderOverlay.show();

                  bool isOk =
                      await ref.read(meetUpRepositoryProvider).postExitMeeting(
                            user_id: userState!.id,
                            meeting_id: meetUpDetailModel!.id,
                          );
                  if (isOk) {
                    await ref.read(chatRepositoryProvider).chatExist(
                          chatRoomUid: meetUpDetailModel!.chat_id,
                          userId: userState!.id,
                        );
                  }
                  if (!mounted) return;
                  context.loaderOverlay.hide();
                  ref.read(homeProvider.notifier).init();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                rightButton: 'meetupDetailScreen.modal.leaveModal.delete'.tr(),
                rightBackgroundColor: kColorBgError,
                rightTextColor: kColorContentError,
                title: 'meetupDetailScreen.modal.leaveModal.title'.tr(),
              );
            },
          ),
          MoreButton(
            text: 'meetupDetailScreen.actionSheet.report'.tr(),
            color: kColorContentError,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(
                    contentType: ReportContentType.Meeting,
                    contentId: widget.meetupId,
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
            text: 'meetupDetailScreen.actionSheet.report'.tr(),
            color: kColorContentError,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(
                    contentType: ReportContentType.Meeting,
                    contentId: widget.meetupId,
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
    systemState = ref.watch(systemProvider);
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
                                            (topic) => NewBadgeWidget(
                                                text: topic.is_custom
                                                    ? topic.kr_name.isNotEmpty
                                                        ? topic.kr_name
                                                        : topic.en_name
                                                    : context.locale
                                                                .languageCode ==
                                                            'en'
                                                        ? topic.en_name
                                                        : topic.kr_name,
                                                type: BadgeType.primary,
                                                size: BadgeSize.M),
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
              "meetupDetailScreen.langLevel.label".tr(),
              style: getTsHeading18(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (systemState is UserSystemModel)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ChipWidget(
                  text: context.locale.languageCode == 'en'
                      ? chartDatas[index].lang.en_name
                      : chartDatas[index].lang.kr_name,
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
                            if (pieTouchResponse
                                    .touchedSection!.touchedSectionIndex ==
                                -1) {
                              return;
                            }
                            if (chartTouchedIndex ==
                                pieTouchResponse
                                    .touchedSection!.touchedSectionIndex) {
                              chartTouchedIndex = chartTouchedIndex;
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
                  chartDatas[chartLangSelectedIndex].description,
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
      if (userState!.profile!.student_verification == null ||
          userState!.profile!.student_verification!.verification_status ==
              VerificationStatus.REJECTED.name) {
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
          child: FilledButtonWidget(
            text: 'meetupDetailScreen.btn.verify'.tr(),
            isEnable: true,
          ),
        );
      } else if (userState!
              .profile!.student_verification!.verification_status ==
          VerificationStatus.PENDING.name) {
        // 학생증 인증 대기 상태
        return FilledButtonWidget(
          text: 'meetupDetailScreen.btn.warning'.tr(),
          isEnable: false,
        );
      } else {
        if (userState!.id == meetUpDetailModel!.creator.id) {
          return GestureDetector(
            onTap: () {
              onTapMembersManagement();
            },
            child: FilledButtonWidget(
              text: 'adminMemberScreen.title'.tr(),
              isEnable: true,
            ),
          );
        } else if (meetUpDetailModel!.participants
            .any((element) => element.id == userState!.id)) {
          return GestureDetector(
            onTap: () {
              onTapChatting();
            },
            child: FilledButtonWidget(
              text: 'meetupDetailScreen.btn.chat'.tr(),
              isEnable: true,
            ),
          );
        } else if (meetUpDetailModel!.current_participants ==
            meetUpDetailModel!.max_participants) {
          return FilledButtonWidget(
            text: 'meetupDetailScreen.btn.full'.tr(),
            isEnable: false,
          );
        } else {
          if (participationStatus != null) {
            if (participationStatus == VerificationStatus.PENDING.name) {
              return FilledButtonWidget(
                text: 'meetupDetailScreen.btn.pending'.tr(),
                isEnable: false,
              );
            } else if (participationStatus == VerificationStatus.PENDING.name) {
              return FilledButtonWidget(
                text: 'meetupDetailScreen.btn.pending'.tr(),
                isEnable: false,
              );
            }
          }
          return GestureDetector(
            onTap: () {
              onTapJoin();
            },
            child: FilledButtonWidget(
              text: 'meetupDetailScreen.btn.request'.tr(),
              isEnable: true,
              height: 52,
            ),
          );
        }
      }
    } else {
      return FilledButtonWidget(
        text: 'meetupDetailScreen.btn.end'.tr(),
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
                  "meetupDetailScreen.members".tr(),
                  style: getTsHeading18(context)
                      .copyWith(color: kColorContentDefault),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  (meetUpDetailModel?.participants.length ?? '').toString(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (meetUpDetailModel != null &&
              (((ref.watch(userMeProvider) as UserModel)
                              .user_nationality[0]
                              .nationality
                              .code ==
                          'kr' &&
                      meetUpDetailModel!.korean_count == 0) ||
                  (ref.watch(userMeProvider) as UserModel)
                              .user_nationality[0]
                              .nationality
                              .code !=
                          'kr' &&
                      meetUpDetailModel!.foreign_count == 0))
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
                    meetUpDetailModel!.foreign_count == 0
                        ? 'meetupDetailScreen.firstForeigner'.tr()
                        : 'meetupDetailScreen.firstKorean'.tr(),
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
            "meetupDetailScreen.introduction".tr(),
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
                    label: tag.is_custom
                        ? tag.kr_name.isNotEmpty
                            ? tag.kr_name
                            : tag.en_name
                        : context.locale.languageCode == 'en'
                            ? tag.en_name
                            : tag.kr_name,
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
                              if (meetUpDetailModel != null &&
                                  systemState is UserSystemModel)
                                Text(
                                  meetUpDetailModel!.meeting_time.isEmpty
                                      ? ''
                                      : context.locale.languageCode == 'ko'
                                          ? dateFormatKO.format(
                                              DateTime.parse(meetUpDetailModel!
                                                  .meeting_time),
                                            )
                                          : dateFormatUS.format(
                                              DateTime.parse(meetUpDetailModel!
                                                  .meeting_time),
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
                              if (meetUpDetailModel != null &&
                                  systemState is UserSystemModel)
                                Text(
                                  meetUpDetailModel!.meeting_time.isEmpty
                                      ? ''
                                      : context.locale.languageCode == 'ko'
                                          ? timeFormatKO.format(
                                              DateTime.parse(meetUpDetailModel!
                                                  .meeting_time),
                                            )
                                          : timeFormatUS.format(
                                              DateTime.parse(meetUpDetailModel!
                                                  .meeting_time),
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
                                  '${meetUpDetailModel!.current_participants}/${meetUpDetailModel!.max_participants}${'meetupDetailScreen.langLevel.count'.tr()}',
                                  textAlign: TextAlign.center,
                                  style: getTsBody14Rg(context).copyWith(
                                    color: kColorContentWeak,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Builder(builder: (context) {
                                  bool isKorean = false;
                                  if ((widget.userModel as UserModel)
                                      .user_nationality
                                      .where((element) =>
                                          element.nationality.code
                                              .toLowerCase() ==
                                          'kr')
                                      .isNotEmpty) {
                                    isKorean = true;
                                  }
                                  if (isKorean &&
                                      meetUpDetailModel!.korean_count == 0) {
                                    return NewBadgeWidget(
                                      text: 'meetupDetailScreen.recruitKorean'
                                          .tr(),
                                      type: BadgeType.secondary,
                                      size: BadgeSize.M,
                                    );
                                  } else if (!isKorean &&
                                      meetUpDetailModel!.foreign_count == 0) {
                                    return NewBadgeWidget(
                                      text:
                                          'meetupDetailScreen.recruitForeigner'
                                              .tr(),
                                      type: BadgeType.secondary,
                                      size: BadgeSize.M,
                                    );
                                  } else {
                                    return Container();
                                  }
                                })
                              ],
                            ),
                          ),
                        )
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
                                      context.locale.languageCode == 'en'
                                          ? lang.en_name
                                          : lang.kr_name,
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
              '${chartDatas[chartLangSelectedIndex].dataList[i].title} ${chartDatas[chartLangSelectedIndex].dataList[i].value}${'meetupDetailScreen.langLevel.count'.tr()}',
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
