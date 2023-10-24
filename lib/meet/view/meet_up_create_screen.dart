import 'package:biskit_app/common/components/progress_bar_widget.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_1_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_2_tab.dart';
import 'package:biskit_app/meet/view/meet_up_create_step_3_tab.dart';
import 'package:flutter/material.dart';

import '../../common/components/filled_button_widget.dart';
import '../../common/layout/default_layout.dart';
import 'meet_up_create_step_4_tab.dart';

class MeetUpCreateScreen extends StatefulWidget {
  const MeetUpCreateScreen({super.key});

  @override
  State<MeetUpCreateScreen> createState() => _MeetUpCreateScreenState();
}

class _MeetUpCreateScreenState extends State<MeetUpCreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      pageIndex = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      onTapLeading: () {
        if (pageIndex > 0) {
          controller.animateTo(pageIndex - 1);
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
