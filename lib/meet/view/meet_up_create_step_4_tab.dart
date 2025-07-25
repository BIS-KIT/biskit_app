import 'package:biskit_app/common/components/custom_text_form_field.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/model/topic_model.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MeetUpCreateStep4Tab extends ConsumerStatefulWidget {
  const MeetUpCreateStep4Tab({super.key});

  @override
  ConsumerState<MeetUpCreateStep4Tab> createState() =>
      _MeetUpCreateStep4TabState();
}

class _MeetUpCreateStep4TabState extends ConsumerState<MeetUpCreateStep4Tab> {
  late final FocusNode meetupDescriptionFocusNode;
  late final TextEditingController meetupDescriptionController;
  bool showMeetupDescription = false;
  List<TopicModel>? fixTopics;
  TopicModel? selectedTopic;

  @override
  void initState() {
    super.initState();
    meetupDescriptionFocusNode = FocusNode();
    meetupDescriptionController = TextEditingController();
    init();
  }

  init() {
    setState(() {
      fixTopics = ref.read(createMeetUpProvider.notifier).fixTopics;
    });

    // 선택한 주제중에 fixTopics중에 있다면 주제 선택
    List<int> selectedTopicIds = ref.read(createMeetUpProvider)!.topic_ids;
    for (var element in fixTopics!) {
      if (selectedTopicIds.contains(element.id)) {
        setState(() {
          selectedTopic = element;
        });
        break;
      }
    }

    meetupDescriptionController.text =
        ref.read(createMeetUpProvider)?.description ?? '';

    if (meetupDescriptionController.text.isNotEmpty) {
      setState(() {
        showMeetupDescription = true;
      });
    }
  }

  @override
  void dispose() {
    meetupDescriptionFocusNode.dispose();
    meetupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createMeetUpState = ref.watch(createMeetUpProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: () {
                showBiskitBottomSheet(
                  title: 'selectTopicIconBottomSheet.title'.tr(),
                  rightIcon: 'assets/icons/ic_cancel_line_24.svg',
                  onRightTap: () {
                    Navigator.pop(context);
                  },
                  // customTitleWidget: Padding(
                  //   padding: const EdgeInsets.only(
                  //     top: 20,
                  //     left: 20,
                  //     right: 20,
                  //     bottom: 0,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       const SizedBox(
                  //         width: 44,
                  //         height: 44,
                  //       ),
                  //       Expanded(
                  //         child: Center(
                  //           child: Text(
                  //             '아이콘 선택',
                  //             style: getTsHeading18(context).copyWith(
                  //               color: kColorContentDefault,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.pop(context);
                  //         },
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: SvgPicture.asset(
                  //             'assets/icons/ic_cancel_line_24.svg',
                  //             width: 24,
                  //             height: 24,
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  context: context,
                  contentWidget: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            if (fixTopics != null)
                              ...fixTopics!.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTopic = e;
                                    });
                                    context.pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: ThumbnailIconWidget(
                                      thumbnailIconType:
                                          ThumbnailIconType.network,
                                      iconPath: e.icon_url,
                                      backgroundColor: kColorBgElevation1,
                                      radius: 100,
                                      size: 88,
                                      isSelected: selectedTopic == e,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                    ],
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ThumbnailIconWidget(
                    thumbnailIconType: ThumbnailIconType.network,
                    iconPath: selectedTopic == null
                        ? kCategoryDefaultPath
                        : selectedTopic!.icon_url,
                    radius: 100,
                    size: 88,
                    isSelected: false,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kColorBgInverseWeak,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic_pencil_fill_24.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'createMeetupScreen4.title'.tr(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  onChanged: (value) {
                    ref
                        .read(createMeetUpProvider.notifier)
                        .onChangedName(value);
                  },
                  hintText: 'createMeetupScreen4.title_placeholder'.tr(),
                  initialValue:
                      createMeetUpState != null ? createMeetUpState.name : '',
                  errorText: (createMeetUpState != null &&
                          createMeetUpState.name != null &&
                          createMeetUpState.name!.length < 2)
                      ? 'createMeetupScreen4.title_numError'.tr()
                      : null,
                  maxLength: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (showMeetupDescription)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 144,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kColorBgElevation1,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        width: 1,
                        color: meetupDescriptionFocusNode.hasFocus
                            ? kColorBorderStronger
                            : kColorBgElevation3,
                      ),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        ref
                            .read(createMeetUpProvider.notifier)
                            .onChangedDescription(value);
                      },
                      onTap: () {
                        meetupDescriptionFocusNode.requestFocus();
                      },
                      maxLength: 1000,
                      // initialValue: createMeetUpState?.description,
                      controller: meetupDescriptionController,
                      focusNode: meetupDescriptionFocusNode,
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        hintText:
                            'createMeetupScreen4.addDescription_placeholder'
                                .tr(),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: getTsBody16Rg(context).copyWith(
                          color: kColorContentPlaceholder,
                        ),
                        counterText: '',
                      ),
                      style: kTsEnBody16Rg.copyWith(
                        color: kColorContentWeak,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${meetupDescriptionController.text.length}/1000',
                    style: getTsCaption12Rg(context).copyWith(
                      color: kColorContentWeakest,
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!showMeetupDescription) {
                          showMeetupDescription = true;
                        } else {
                          showConfirmModal(
                            context: context,
                            leftCall: () {
                              Navigator.pop(context);
                            },
                            leftButton: 'deleteDescriptionModal.cancel'.tr(),
                            rightCall: () {
                              ref
                                  .read(createMeetUpProvider.notifier)
                                  .onChangedDescription('');
                              setState(() {
                                showMeetupDescription = false;
                              });
                              Navigator.pop(context);
                            },
                            rightButton: 'deleteDescriptionModal.delete'.tr(),
                            rightBackgroundColor: kColorBgError,
                            rightTextColor: kColorContentError,
                            title: 'deleteDescriptionModal.title'.tr(),
                          );
                        }
                      });
                    },
                    child: OutlinedButtonWidget(
                      text: !showMeetupDescription
                          ? 'createMeetupScreen4.addDescription'.tr()
                          : 'createMeetupScreen4.deleteDescription'.tr(),
                      leftIconPath: !showMeetupDescription
                          ? 'assets/icons/ic_plus_line_24.svg'
                          : 'assets/icons/ic_cancel_line_24.svg',
                      isEnable: true,
                      height: 44,
                    ),
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
