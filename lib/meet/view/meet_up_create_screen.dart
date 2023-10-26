import 'package:biskit_app/common/components/progress_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/provider/meet_up_provider.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_1_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_2_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_3_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);

    // 임시저장 있으면 알림창 보여준다
    SchedulerBinding.instance.addPostFrameCallback((_) => checkTempWrite());
  }

  checkTempWrite() {
    final bool isWritten = ref.read(createMeetUpProvider).isWritten;
    logger.d('isWritten : $isWritten');
    if (isWritten) {
      showConfirmModal(
        context: context,
        title: '모임을 이어서 만드시겠어요?',
        content: '임시저장된 정보가 있어요',
        leftCall: () {
          ref.read(createMeetUpProvider.notifier).init();
          Navigator.pop(context);
        },
        leftButton: '취소',
        rightCall: () {
          // TODO 임시 저장된 데이터로 셋팅
          controller.animateTo(ref.read(createMeetUpProvider).pageIndex);
          Navigator.pop(context);
        },
        rightButton: '만들기',
        rightBackgroundColor: kColorBgPrimary,
        rightTextColor: kColorContentOnBgPrimary,
      );
    }
  }

  @override
  void dispose() {
    logger.d('dispose:MeetUpCreateScreen');
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      pageIndex = controller.index;
    });
    ref.read(createMeetUpProvider.notifier).setPageIndex(controller.index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      onTapLeading: () {
        if (pageIndex > 0) {
          controller.animateTo(pageIndex - 1);
        } else if (pageIndex == 0) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            ProgressBarWidget(
              isFirstDone: true,
              isSecondDone: pageIndex > 0,
              isThirdDone: pageIndex > 1,
              isFourthDone: pageIndex > 2,
            ),

            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: const [
                  MeetUpCreateStep1Tab(),
                  MeetUpCreateStep2Tab(),
                  MeetUpCreateStep3Tab(),
                  MeetUpCreateStep4Tab(),
                ],
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {
                  if (pageIndex >= 0 && pageIndex < 3) {
                    controller.animateTo(pageIndex + 1);
                  }
                },
                child: FilledButtonWidget(
                  height: 56,
                  text: pageIndex == 3 ? '모이 만들기' : '다음',
                  isEnable: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
