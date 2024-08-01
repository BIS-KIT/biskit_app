import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/common/components/progress_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/meet/view/meet_up_create_select_school_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_1_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_2_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_3_tab.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/components/filled_button_widget.dart';
import '../../common/layout/default_layout.dart';
import 'meet_up_create_step_4_tab.dart';

class MeetUpCreateScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final int? editMeetingId;
  const MeetUpCreateScreen({
    super.key,
    this.isEditMode = false,
    this.editMeetingId,
  });

  @override
  ConsumerState<MeetUpCreateScreen> createState() => _MeetUpCreateScreenState();
}

class _MeetUpCreateScreenState extends ConsumerState<MeetUpCreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int pageIndex = 0;
  String? selectedLang;

  List<TopicModel> topics = [];
  List<TagModel> tags = [];

  bool isCreateLoading = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller.addListener(tabListener);
    init();

    // 기획에서 임시저장 기능 안하기로 결정
    // 임시저장 있으면 알림창 보여준다
    // SchedulerBinding.instance.addPostFrameCallback((_) => checkTempWrite());
  }

  init() async {
    List<TopicModel> tempList = await ref
        .read(createMeetUpProvider.notifier)
        .getTopics(isCustom: false);
    List<TagModel> tempTagList =
        await ref.read(createMeetUpProvider.notifier).getTags(isCustom: false);
    setState(() {
      topics = tempList;
      tags = tempTagList;
    });
    ref.read(createMeetUpProvider.notifier).setFixData(
          tags: tags,
        );
  }

  // checkTempWrite() {
  //   final bool isWritten = ref.read(createMeetUpProvider).isWritten;
  //   logger.d('isWritten : $isWritten');
  //   if (isWritten) {
  //     showConfirmModal(
  //       context: context,
  //       title: '모임을 이어서 만드시겠어요?',
  //       content: '임시저장된 정보가 있어요',
  //       leftCall: () {
  //         ref.read(createMeetUpProvider.notifier).init();
  //         Navigator.pop(context);
  //       },
  //       leftButton: '취소',
  //       rightCall: () {
  //         // 임시 저장된 데이터로 셋팅
  //         controller.animateTo(ref.read(createMeetUpProvider).pageIndex);
  //         Navigator.pop(context);
  //       },
  //       rightButton: '만들기',
  //       rightBackgroundColor: kColorBgPrimary,
  //       rightTextColor: kColorContentOnBgPrimary,
  //     );
  //   }
  // }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      pageIndex = controller.index;
    });
    // ref.read(createMeetUpProvider.notifier).setPageIndex(controller.index);
  }

  Future<bool> onWillPop() async {
    bool isPop = false;
    if (pageIndex > 0) {
      controller.animateTo(pageIndex - 1);
    } else if (pageIndex == 0) {
      if (widget.isEditMode) {
        await showConfirmModal(
          context: context,
          leftCall: () {
            Navigator.pop(context);
          },
          leftButton: 'meetupDetailScreen.modal.cancelEditModal.continue'.tr(),
          rightCall: () {
            isPop = true;
            ref.read(createMeetUpProvider.notifier).init();
            Navigator.pop(context);
            Navigator.pop(context, [true]);
          },
          rightButton: 'meetupDetailScreen.modal.cancelEditModal.cancel'.tr(),
          rightBackgroundColor: kColorBgError,
          rightTextColor: kColorContentError,
          title: 'meetupDetailScreen.modal.cancelEditModal.title'.tr(),
          content: 'meetupDetailScreen.modal.cancelEditModal.subtitle'.tr(),
        );
      } else {
        await showConfirmModal(
          context: context,
          leftCall: () {
            Navigator.pop(context);
          },
          leftButton: 'leavePageModal.cancel'.tr(),
          rightCall: () {
            isPop = true;
            ref.read(createMeetUpProvider.notifier).init();
            Navigator.pop(context);
            Navigator.pop(context, [true]);
          },
          rightButton: 'leavePageModal.leave'.tr(),
          rightBackgroundColor: kColorBgError,
          rightTextColor: kColorContentError,
          title: 'leavePageModal.title'.tr(),
          content: 'leavePageModal.subtitle'.tr(),
        );
      }
    }
    return isPop;
  }

  isButtonEnable() {
    if (isCreateLoading) {
      return false;
    }
    final createMeetUpState = ref.watch(createMeetUpProvider);
    if (createMeetUpState != null) {
      if (pageIndex == 0) {
        if ((createMeetUpState.is_public != null)) {
          return true;
        }
      }
      if (pageIndex == 1) {
        if ((createMeetUpState.topic_ids.isNotEmpty ||
                createMeetUpState.custom_topics.isNotEmpty) &&
            createMeetUpState.location != null) {
          return true;
        }
      } else if (pageIndex == 2) {
        return true;
      } else if (pageIndex == 3) {
        if ((createMeetUpState.tag_ids.isNotEmpty ||
                createMeetUpState.custom_tags.isNotEmpty) &&
            createMeetUpState.language_ids.isNotEmpty) {
          return true;
        }
      } else if (pageIndex == 4) {
        if (createMeetUpState.name != null &&
            createMeetUpState.name!.length >= 2) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final padding = MediaQuery.of(context).padding;
    final userState = ref.read(userMeProvider);

    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultLayout(
        title: '',
        leadingIconPath: pageIndex == 0
            ? 'assets/icons/ic_cancel_line_24.svg'
            : 'assets/icons/ic_arrow_back_ios_line_24.svg',
        backgroundColor: kColorBgDefault,
        onTapLeading: onWillPop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pageIndex != 0)
              const SizedBox(
                height: 4,
              ),
            if (pageIndex != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProgressBarWidget(
                  isFirstDone: pageIndex > 0,
                  isSecondDone: pageIndex > 1,
                  isThirdDone: pageIndex > 2,
                  isFourthDone: pageIndex > 3,
                ),
              ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  MeetUpCreateSelectSchoolTab(controller: controller),
                  MeetUpCreateStep1Tab(
                    topics: topics,
                    systemModel: ref.watch(systemProvider),
                    topPadding: padding.top,
                  ),
                  MeetUpCreateStep2Tab(
                    systemModel: ref.watch(systemProvider),
                  ),
                  MeetUpCreateStep3Tab(
                    tags: tags,
                  ),
                  const MeetUpCreateStep4Tab(),
                ],
              ),
            ),

            // 하단 버튼
            Builder(builder: (context) {
              if (viewInsets.bottom <= 150) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 34,
                    left: 20,
                    right: 20,
                  ),
                  child: GestureDetector(
                    onTap: (isCreateLoading || userState is! UserModel)
                        ? null
                        : () async {
                            onTapSubmitButton(userState);
                          },
                    child: FilledButtonWidget(
                      height: 56,
                      text: pageIndex == 4
                          ? widget.isEditMode
                              ? 'createMeetupScreen4.editComplete'.tr()
                              : 'createMeetupScreen4.createMeetup'.tr()
                          : 'createMeetupScreen1.next'.tr(),
                      isEnable: isButtonEnable(),
                    ),
                  ),
                );
              } else {
                if (pageIndex == 4) {
                  return GestureDetector(
                    onTap: (isCreateLoading || userState is! UserModel)
                        ? null
                        : () {
                            onTapSubmitButton(userState);
                          },
                    child: FilledButtonWidget(
                      height: 52,
                      text: pageIndex == 4
                          ? widget.isEditMode
                              ? 'createMeetupScreen4.editComplete'.tr()
                              : 'createMeetupScreen4.createMeetup'.tr()
                          : 'createMeetupScreen3.next'.tr(),
                      isEnable: isButtonEnable(),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  void onTapSubmitButton(UserModel userState) async {
    try {
      if (isButtonEnable()) {
        setState(() {
          isCreateLoading = true;
        });
        if (pageIndex >= 0 && pageIndex < 4) {
          controller.animateTo(pageIndex + 1);
        } else {
          if (widget.isEditMode) {
            context.loaderOverlay.show();

            bool result = false;
            result = await ref
                .read(createMeetUpProvider.notifier)
                .putUpdateMeetUp(widget.editMeetingId!);
            ref.read(meetUpProvider.notifier).paginate(forceRefetch: true);

            if (result && mounted) {
              context.loaderOverlay.hide();
              Navigator.pop(context, widget.isEditMode ? true : [true]);
            }
          } else {
            context.loaderOverlay.show();
            int? result =
                await ref.read(createMeetUpProvider.notifier).createMeetUp();
            if (result != null) {
              MeetUpModel model =
                  await ref.read(meetUpRepositoryProvider).getMeeting(result);

              // 채팅방 입장
              await ref.read(chatRepositoryProvider).goChatRoom(
                    chatRoomUid: model.chat_id,
                    user: userState,
                  );

              if (!mounted) return;
              context.loaderOverlay.hide();
              ref.read(meetUpProvider.notifier).paginate(forceRefetch: true);

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetUpDetailScreen(
                    meetupId: model.id,
                    userModel: userState,
                  ),
                ),
              );
            }
          }
        }
      }
    } finally {
      setState(() {
        isCreateLoading = false;
      });
    }
  }
}
