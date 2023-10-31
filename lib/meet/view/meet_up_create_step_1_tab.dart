import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/components/chip_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/place_search_screen.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';

class MeetUpCreateStep1Tab extends ConsumerStatefulWidget {
  final List<TopicModel> fixTopics;
  final double topPadding;
  const MeetUpCreateStep1Tab({
    super.key,
    required this.fixTopics,
    required this.topPadding,
  });

  @override
  ConsumerState<MeetUpCreateStep1Tab> createState() =>
      _MeetUpCreateStep1TabState();
}

class _MeetUpCreateStep1TabState extends ConsumerState<MeetUpCreateStep1Tab> {
  // List<String> selectedSubjectList = [];
  String customSubject = '직접입력';
  late FocusNode customSubjectFocusNode;

  @override
  void initState() {
    super.initState();
    customSubjectFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    customSubjectFocusNode.dispose();
  }

  void onWriteChip(String subject) {
    FocusScope.of(context).requestFocus();
    setState(() {
      customSubject = subject;
    });
  }

  @override
  Widget build(BuildContext context) {
    final createMeetUpState = ref.watch(createMeetUpProvider);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Text(
                  '무엇을 할건가요?',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '3개까지 선택 가능해요',
                  style: getTsBody14Rg(context).copyWith(
                    color: kColorContentWeaker,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (createMeetUpState != null)
                  Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      ...widget.fixTopics
                          .map(
                            (e) => ChipWidget(
                              text: e.kr_name,
                              isSelected:
                                  createMeetUpState.topic_ids.contains(e.id),
                              onClickSelect: () {
                                ref
                                    .read(createMeetUpProvider.notifier)
                                    .onTapTopic(e.id);
                              },
                            ),
                          )
                          .toList(),
                      ChipWidget(
                        text: customSubject,
                        isSelected: false,
                        onTapAdd: onWriteChip,
                        onTapDelete: null,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 48,
                ),
                Text(
                  '어디서 만날까요?',
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    final location = await showBiskitBottomSheet(
                      context: context,
                      title: '장소 검색',
                      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                      height: MediaQuery.of(context).size.height -
                          widget.topPadding -
                          48,
                      contentWidget: PlaceSearchScreen(
                        isEng: context.locale.languageCode == kEn,
                      ),
                      onRightTap: () {
                        Navigator.pop(context);
                      },
                    );
                    logger.d(location);
                    if (location != null) {
                      ref
                          .read(createMeetUpProvider.notifier)
                          .setLocation(location);
                    }
                  },
                  child: OutlinedButtonWidget(
                    height: 52,
                    text: createMeetUpState!.location == null
                        ? '장소 선택'
                        : createMeetUpState.location ?? '',
                    isEnable: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
