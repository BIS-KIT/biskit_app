import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';

import '../../common/components/chip_widget.dart';

class MeetUpCreateStep3Tab extends ConsumerStatefulWidget {
  final List<TagModel> tags;
  const MeetUpCreateStep3Tab({
    super.key,
    required this.tags,
  });

  @override
  ConsumerState<MeetUpCreateStep3Tab> createState() =>
      _MeetUpCreateStep3TabState();
}

class _MeetUpCreateStep3TabState extends ConsumerState<MeetUpCreateStep3Tab> {
  late FocusNode customTagFocusNode;
  late final TextEditingController customTagController;

  @override
  void initState() {
    super.initState();
    customTagFocusNode = FocusNode();
    customTagController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    customTagFocusNode.dispose();
    customTagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    final createMeetUpState = ref.watch(createMeetUpProvider);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (customTagController.text != '') {
            ref
                .read(createMeetUpProvider.notifier)
                .onTapAddCustomTopic(customTagController.text);
          }
          setState(() {
            customTagController.text = '';
          });
        },
        child: Padding(
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
                    '모임에서 사용하고 싶은 언어를\n순서대로 선택해주세요',
                    style: getTsHeading18(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (userState != null && userState is UserModel)
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        ...userState.profile!.available_languages.map((e) {
                          int index = createMeetUpState!.language_ids
                              .indexWhere(
                                  (element) => element == e.language.id);
                          return ChipWidget(
                            text: e.language.kr_name,
                            order: index > -1 ? index + 1 : null,
                            isSelected: createMeetUpState.language_ids
                                .contains(e.language.id),
                            onClickSelect: () {
                              ref
                                  .read(createMeetUpProvider.notifier)
                                  .onTapLang(e);
                            },
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '태그로 모임을 소개해보세요',
                    style: getTsHeading18(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      ...widget.tags.map(
                        (e) => ChipWidget(
                          text: e.kr_name,
                          isSelected: createMeetUpState!.tag_ids.contains(e.id),
                          onClickSelect: () {
                            ref.read(createMeetUpProvider.notifier).onTapTag(e);
                          },
                        ),
                      ),
                      ...createMeetUpState!.custom_tags.map(
                        (e) => ChipWidget(
                          text: e,
                          isSelected: createMeetUpState.custom_tags.contains(e),
                          onClickSelect: () {
                            ref
                                .read(createMeetUpProvider.notifier)
                                .onTapDeleteCustomTag(e);
                          },
                          onTapDelete: () {
                            ref
                                .read(createMeetUpProvider.notifier)
                                .onTapDeleteCustomTag(e);
                          },
                        ),
                      ),
                      ChipWidget(
                        text: "직접입력",
                        isSelected: false,
                        onTapEnter: (e) {
                          ref
                              .read(createMeetUpProvider.notifier)
                              .onTapAddCustomTag(customTagController.text);
                          setState(() {
                            customTagController.text = '';
                          });
                        },
                        onTapAdd: (e) {
                          customTagFocusNode.requestFocus();
                        },
                        focusNode: customTagFocusNode,
                        controller: customTagController,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
