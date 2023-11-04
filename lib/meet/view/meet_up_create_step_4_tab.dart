import 'package:biskit_app/common/components/custom_text_form_field.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
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
  dynamic selectedSubject = {};
  final List<dynamic> subjectList = [
    {'value': '식사', 'imgUrl': 'assets/icons/ic_restaurant_fill_48.svg'},
    {'value': '카페', 'imgUrl': 'assets/icons/ic_cafe_fill_48.svg'},
    {'value': '액티비티', 'imgUrl': 'assets/icons/ic_activity_fill_48.svg'},
    {
      'value': '언어교환',
      'imgUrl': 'assets/icons/ic_language_exchange_fill_48.svg'
    },
    {'value': '스터디', 'imgUrl': 'assets/icons/ic_study_fill_48.svg'},
    {'value': '문화·예술', 'imgUrl': 'assets/icons/ic_culture_fill_48.svg'},
    {'value': '여행', 'imgUrl': 'assets/icons/ic_travel_fill_48.svg'},
    {'value': '취미', 'imgUrl': 'assets/icons/ic_friends_fill_48.svg'},
  ];

  late final FocusNode meetupDescriptionFocusNode;
  late final TextEditingController meetupDescriptionController;
  bool showMeetupDescription = false;

  @override
  void initState() {
    super.initState();
    meetupDescriptionFocusNode = FocusNode();
    meetupDescriptionController = TextEditingController();
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

    return Padding(
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
                title: '',
                customTitleWidget: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '아이콘 선택',
                            style: getTsHeading18(context).copyWith(
                              color: kColorContentDefault,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icons/ic_cancel_line_24.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                context: context,
                contentWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Wrap(
                    children: [
                      ...subjectList.map(
                        (e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSubject = e;
                            });
                            context.pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ThumbnailIconWidget(
                              iconUrl: e['imgUrl'],
                              isSelected:
                                  selectedSubject['value'] == e['value'],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ThumbnailIconWidget(
                  iconUrl: selectedSubject['value'] != null
                      ? selectedSubject['imgUrl']
                      : 'assets/icons/ic_restaurant_fill_48.svg',
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
                '제목을 입력해주세요',
                style: getTsHeading18(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                onChanged: (value) {
                  ref.read(createMeetUpProvider.notifier).onChangedName(value);
                },
                errorText: (createMeetUpState != null &&
                        createMeetUpState.name != null &&
                        createMeetUpState.name!.length < 5)
                    ? '5자 이상으로 입력해주세요'
                    : null,
                maxLength: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          !showMeetupDescription
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showMeetupDescription = true;
                        });
                      },
                      child: const OutlinedButtonWidget(
                        text: '모임설명 추가',
                        leftIconPath: 'assets/icons/ic_plus_line_24.svg',
                        isEnable: true,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 144,
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kColorBgElevation1,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
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
                        controller: meetupDescriptionController,
                        focusNode: meetupDescriptionFocusNode,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          hintText: '모임설명을 입력해주세요',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: getTsBody16Rg(context).copyWith(
                            color: kColorContentPlaceholder,
                          ),
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
                      '${meetupDescriptionController.text.length}/500',
                      style: getTsCaption12Rg(context).copyWith(
                        color: kColorContentWeakest,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
