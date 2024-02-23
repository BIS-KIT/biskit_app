import 'package:biskit_app/common/components/calendar_widget.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/stepper_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/utils/date_util.dart';

class MeetUpCreateStep2Tab extends ConsumerStatefulWidget {
  final UserSystemModelBase? systemModel;

  const MeetUpCreateStep2Tab({super.key, required this.systemModel});

  @override
  ConsumerState<MeetUpCreateStep2Tab> createState() =>
      _MeetUpCreateStep2TabState();
}

class _MeetUpCreateStep2TabState extends ConsumerState<MeetUpCreateStep2Tab> {
  final DateFormat dateFormatUS = DateFormat('MM/dd (E) a hh:mm', 'en_US');
  final DateFormat dateFormatKO = DateFormat('MM/dd (E) a hh:mm', 'ko_KR');

  DateTime? selectedDateTime;
  // int limitNum = 2;

  @override
  initState() {
    super.initState();

    init();
  }

  init() {
    final state = ref.read(createMeetUpProvider);
    if (state == null || state.meeting_time == null) {
      setState(() {
        selectedDateTime =
            getDateTimeIntervalMin5().add(const Duration(hours: 2));
      });
      Future.microtask(
        () => ref
            .read(createMeetUpProvider.notifier)
            .setMeetDate(selectedDateTime!),
      );
    } else {
      final dateTime = ref.read(createMeetUpProvider.notifier).getMeetDate();
      setState(() {
        selectedDateTime = dateTime;
      });
    }
  }

  onTapDate() async {
    DateTime? tempDay = selectedDateTime;
    tempDay = await showBiskitBottomSheet(
      context: context,
      title: '',
      customTitleWidget: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 0,
        ),
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
                  'selectDateBottomSheet.title'.tr(),
                  style: getTsHeading18(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, null);
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
      contentWidget: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: CalendarWidget(
              selectedDay: tempDay,
              onDaySelected: (value) {
                tempDay = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 34,
              left: 20,
              right: 20,
            ),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(
                  context,
                  tempDay,
                );
              },
              child: FilledButtonWidget(
                text: 'selectDateBottomSheet.next'.tr(),
                isEnable: true,
              ),
            ),
          )
        ],
      ),
    );

    if (tempDay != null) {
      setState(() {
        selectedDateTime = tempDay;
      });
      ref.read(createMeetUpProvider.notifier).setMeetDate(tempDay!);
      if (!mounted) return;
      DateTime tempTime = selectedDateTime!.add(const Duration(hours: 2));
      final time = await showTimeBottomSheet(
        context: context,
        time: tempTime,
        onTapBack: () {
          onTapDate();
        },
      );
      if (time != null) {
        setState(() {
          selectedDateTime = time;
        });
        ref.read(createMeetUpProvider.notifier).setMeetDate(time!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final createMeetUpState = ref.watch(createMeetUpProvider);
    return Padding(
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
                'createMeetupScreen2.title1'.tr(),
                style: getTsHeading18(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: onTapDate,
                child: OutlinedButtonWidget(
                  text: selectedDateTime == null
                      ? ''
                      : widget.systemModel is UserSystemModel &&
                              (widget.systemModel as UserSystemModel)
                                      .system_language ==
                                  'kr'
                          ? dateFormatKO.format(selectedDateTime!)
                          : dateFormatUS.format(selectedDateTime!),
                  height: 52,
                  isEnable: true,
                ),
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
                'createMeetupScreen2.title2'.tr(),
                style: getTsHeading18(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StepperWidget(
                onClickMinus:
                    ref.read(createMeetUpProvider.notifier).onClickMinus,
                onClickPlus:
                    ref.read(createMeetUpProvider.notifier).onClickPlus,
                value: createMeetUpState == null
                    ? 0
                    : createMeetUpState.max_participants,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
