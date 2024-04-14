import 'package:biskit_app/chat/repository/chat_repository.dart';
import 'package:biskit_app/chat/view/chat_screen.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/date_util.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/setting/model/user_system_model.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScheduleCardWidget extends ConsumerWidget {
  final MeetUpModel meetUpModel;
  final UserSystemModelBase? systemModel;
  final double width;
  const ScheduleCardWidget({
    Key? key,
    required this.meetUpModel,
    required this.systemModel,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final DateFormat dateFormatUS = DateFormat('MM/dd (EEE)', 'en_US');
    final DateFormat dateFormatKO = DateFormat('MM/dd (EEE)', 'ko_KR');
    final DateFormat timeFormatUS = DateFormat('a h:mm', 'en_US');
    final DateFormat timeFormatKO = DateFormat('a h:mm', 'ko_KR');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetUpDetailScreen(
              meetupId: meetUpModel.id,
              userModel: ref.watch(userMeProvider),
            ),
          ),
        );
      },
      child: Container(
        width: width,
        height: 249,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x11495B7D),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x07495B7D),
              blurRadius: 1,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            // Section1
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                color: kColorBgElevation1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getMeetUpDateStr(
                          meetUpDateStr: meetUpModel.meeting_time,
                          dateFormat: context.locale.languageCode == 'ko'
                              ? dateFormatKO
                              : dateFormatUS,
                        ),
                        // meetUpModel.meeting_time.isEmpty
                        //     ? ''
                        //     : dateFormat1.format(
                        //         DateTime.parse(meetUpModel.meeting_time)),
                        style: getTsHeading18(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        meetUpModel.meeting_time.isEmpty
                            ? ''
                            : context.locale.languageCode == 'ko'
                                ? timeFormatKO.format(
                                    DateTime.parse(meetUpModel.meeting_time))
                                : timeFormatUS.format(
                                    DateTime.parse(meetUpModel.meeting_time)),
                        style: getTsHeading18(context).copyWith(
                          color: kColorContentWeak,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_pin_fill_24.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          kColorContentWeaker,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        meetUpModel.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTsBody16Sb(context).copyWith(
                          color: kColorContentWeaker,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Section2
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 20,
                bottom: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: kColorBgDefault,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ThumbnailIconWidget(
                        size: 40,
                        padding: 4,
                        iconSize: 24,
                        isSelected: false,
                        radius: 8,
                        iconPath: meetUpModel.image_url ?? kCategoryDefaultPath,
                        thumbnailIconType: ThumbnailIconType.network,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          meetUpModel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getTsBody14Rg(context).copyWith(
                            color: kColorContentWeaker,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      onTapChat(ref, context);
                    },
                    child: OutlinedButtonWidget(
                      text: 'homeScreen.chat'.tr(),
                      isEnable: true,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapChat(WidgetRef ref, BuildContext context) async {
    final userState = ref.watch(userMeProvider);
    if (userState != null && userState is UserModel) {
      await ref.read(chatRepositoryProvider).goChatRoom(
            chatRoomUid: meetUpModel.chat_id,
            user: userState,
          );

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatRoomUid: meetUpModel.chat_id,
          ),
        ),
      );
    }
  }
}
