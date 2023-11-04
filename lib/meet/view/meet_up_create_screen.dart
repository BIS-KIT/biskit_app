import 'package:biskit_app/common/components/progress_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_1_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_2_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_3_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/components/filled_button_widget.dart';
import '../../common/layout/default_layout.dart';
import 'meet_up_create_step_4_tab.dart';

class MeetUpCreateScreen extends ConsumerStatefulWidget {
  const MeetUpCreateScreen({super.key});

  @override
  ConsumerState<MeetUpCreateScreen> createState() => _MeetUpCreateScreenState();
}

class _MeetUpCreateScreenState extends ConsumerState<MeetUpCreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int pageIndex = 0;

  List<TopicModel> fixTopics = [];
  List<TagModel> tags = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
    init();

    // 기획에서 임시저장 기능 안하기로 결정
    // 임시저장 있으면 알림창 보여준다
    // SchedulerBinding.instance.addPostFrameCallback((_) => checkTempWrite());
  }

  init() async {
    List<TopicModel> tempList =
        await ref.read(createMeetUpProvider.notifier).getTopics();
    List<TagModel> tempTagList =
        await ref.read(createMeetUpProvider.notifier).getTags();
    setState(() {
      fixTopics = tempList;
      tags = tempTagList;
    });
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
  //         // TODO 임시 저장된 데이터로 셋팅
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
      await showConfirmModal(
        context: context,
        leftCall: () {
          Navigator.pop(context);
        },
        leftButton: '취소',
        rightCall: () {
          isPop = true;
          ref.read(createMeetUpProvider.notifier).init();
          Navigator.pop(context);
          Navigator.pop(context, true);
        },
        rightButton: '나가기',
        rightBackgroundColor: kColorBgError,
        rightTextColor: kColorContentError,
        title: '나가시겠어요?',
        content: '작성한 모임 정보가 모두 사라져요',
      );
    }
    return isPop;
  }

  isButtonEnable() {
    final createMeetUpState = ref.watch(createMeetUpProvider);
    if (createMeetUpState != null) {
      if (pageIndex == 0) {
        if ((createMeetUpState.topic_ids.isNotEmpty ||
                createMeetUpState.custom_topics.isNotEmpty) &&
            createMeetUpState.location != null) {
          return true;
        }
      } else if (pageIndex == 1) {
        return true;
      } else if (pageIndex == 2) {
        if ((createMeetUpState.tag_ids.isNotEmpty ||
                createMeetUpState.custom_tags.isNotEmpty) &&
            createMeetUpState.language_ids.isNotEmpty) {
          return true;
        }
      } else if (pageIndex == 3) {
        if (createMeetUpState.name != null &&
            createMeetUpState.name!.length >= 5) {
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
    final createMeetUpState = ref.watch(createMeetUpProvider);

    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultLayout(
        title: '',
        onTapLeading: onWillPop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProgressBarWidget(
                isFirstDone: true,
                isSecondDone: pageIndex > 0,
                isThirdDone: pageIndex > 1,
                isFourthDone: pageIndex > 2,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  MeetUpCreateStep1Tab(
                    fixTopics: fixTopics,
                    topPadding: padding.top,
                  ),
                  const MeetUpCreateStep2Tab(),
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
                    onTap: () {
                      if (isButtonEnable()) {
                        if (pageIndex >= 0 && pageIndex < 3) {
                          controller.animateTo(pageIndex + 1);

                          logger.d(createMeetUpState);
                        }
                      }
                    },
                    child: FilledButtonWidget(
                      height: 56,
                      text: pageIndex == 3 ? '모임 만들기' : '다음',
                      isEnable: isButtonEnable(),
                    ),
                  ),
                );
              } else {
                if (pageIndex == 3) {
                  return GestureDetector(
                    onTap: () async {
                      if (isButtonEnable()) {
                        if (pageIndex >= 0 && pageIndex < 3) {
                          controller.animateTo(pageIndex + 1);

                          logger.d(createMeetUpState);
                        } else if (pageIndex == 3) {
                          final result = await ref
                              .read(createMeetUpProvider.notifier)
                              .createMeetUp();
                          if (result) {
                            if (!mounted) return;
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: FilledButtonWidget(
                      height: 56,
                      text: pageIndex == 3 ? '모임 만들기' : '다음',
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
}
