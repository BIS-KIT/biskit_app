import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/tag_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/profile/model/available_language_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (customTagController.text != '') {
          ref
              .read(createMeetUpProvider.notifier)
              .onTapAddCustomTag(customTagController.text);
        }
        setState(() {
          customTagController.text = '';
        });
      },
      child: SingleChildScrollView(
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
                    'createMeetupScreen3.title1'.tr(),
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
                        ...createMeetUpState!.language_ids
                            .mapIndexed((index, id) {
                          AvailableLanguageModel languageModel =
                              userState.profile!.available_languages.firstWhere(
                                  (element) => element.language.id == id);
                          return ChipWidget(
                            text: context.locale.languageCode == 'en'
                                ? languageModel.language.en_name
                                : languageModel.language.kr_name,
                            order: index + 1,
                            isSelected: true,
                            onClickSelect: () {
                              ref
                                  .read(createMeetUpProvider.notifier)
                                  .onTapLang(languageModel);
                            },
                          );
                        }).toList(),
                        ...userState.profile!.available_languages
                            .where((e1) => !createMeetUpState.language_ids
                                .contains(e1.language.id))
                            .map((e) {
                          return ChipWidget(
                            text: context.locale.languageCode == 'en'
                                ? e.language.en_name
                                : e.language.kr_name,
                            order: null,
                            isSelected: false,
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
                    'createMeetupScreen3.title2'.tr(),
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
                      if (createMeetUpState!.custom_tags.length < 10)
                        ChipWidget(
                          text: "createMeetupScreen3.createChip".tr(),
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
                      ...createMeetUpState.custom_tags.map(
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
                      ...widget.tags.map(
                        (e) => ChipWidget(
                          text: context.locale.languageCode == 'en'
                              ? e.en_name
                              : e.kr_name,
                          isSelected: createMeetUpState.tag_ids.contains(e.id),
                          onClickSelect: () {
                            ref.read(createMeetUpProvider.notifier).onTapTag(e);
                          },
                        ),
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
