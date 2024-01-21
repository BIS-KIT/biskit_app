import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/setting/provider/system_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final List<TopicModel> topics;
  final double topPadding;
  final String selectedLang;

  const MeetUpCreateStep1Tab({
    super.key,
    required this.topics,
    required this.topPadding,
    required this.selectedLang,
  });

  @override
  ConsumerState<MeetUpCreateStep1Tab> createState() =>
      _MeetUpCreateStep1TabState();
}

class _MeetUpCreateStep1TabState extends ConsumerState<MeetUpCreateStep1Tab> {
  late FocusNode customTopicFocusNode;
  late final TextEditingController customTopicController;

  @override
  void initState() {
    super.initState();
    customTopicFocusNode = FocusNode();
    customTopicController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    customTopicFocusNode.dispose();
    customTopicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createMeetUpState = ref.watch(createMeetUpProvider);
    List<TopicModel> topicList = widget.topics;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (customTopicController.text != '') {
          ref
              .read(createMeetUpProvider.notifier)
              .onTapAddCustomTopic(customTopicController.text);
        }
        setState(() {
          customTopicController.text = '';
        });
      },
      child: Scaffold(
        backgroundColor: kColorBgDefault,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SingleChildScrollView(
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
                      'createMeetupScreen1.title1'.tr(),
                      style: getTsHeading18(context).copyWith(
                        color: kColorContentDefault,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'createMeetupScreen1.subtitle1'.tr(),
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
                          ...topicList
                              .map(
                                (e) => ChipWidget(
                                  text: widget.selectedLang == 'kr'
                                      ? e.kr_name
                                      : e.en_name,
                                  isSelected: createMeetUpState.topic_ids
                                      .contains(e.id),
                                  onClickSelect: () {
                                    ref
                                        .read(createMeetUpProvider.notifier)
                                        .onTapTopic(e.id);
                                  },
                                ),
                              )
                              .toList(),
                          ...createMeetUpState.custom_topics.map(
                            (e) => ChipWidget(
                              text: e,
                              isSelected:
                                  createMeetUpState.custom_topics.contains(e),
                              onClickSelect: () {
                                ref
                                    .read(createMeetUpProvider.notifier)
                                    .onTapDeleteCustomTopic(e);
                              },
                              onTapDelete: () {
                                ref
                                    .read(createMeetUpProvider.notifier)
                                    .onTapDeleteCustomTopic(e);
                              },
                            ),
                          ),
                          if (createMeetUpState.topic_ids.length +
                                  createMeetUpState.custom_topics.length <
                              3)
                            ChipWidget(
                              text: 'createMeetupScreen1.chip8'.tr(),
                              isSelected: false,
                              onTapEnter: (e) {
                                ref
                                    .read(createMeetUpProvider.notifier)
                                    .onTapAddCustomTopic(
                                        customTopicController.text);
                                setState(() {
                                  customTopicController.text = '';
                                });
                              },
                              onTapAdd: (e) {
                                customTopicFocusNode.requestFocus();
                              },
                              focusNode: customTopicFocusNode,
                              controller: customTopicController,
                            ),
                        ],
                      ),
                    const SizedBox(
                      height: 48,
                    ),
                    Text(
                      'createMeetupScreen1.title2'.tr(),
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
                          title: 'selectLocationBottomSheet.find'.tr(),
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
                        maxLines: 1,
                        text: createMeetUpState!.location == null
                            ? 'selectLocationBottomSheet.title'.tr()
                            : createMeetUpState.location ?? '',
                        isEnable: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
