import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/meet/provider/create_meet_up_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetUpCreateSelectSchoolTab extends ConsumerStatefulWidget {
  final TabController controller;
  const MeetUpCreateSelectSchoolTab({super.key, required this.controller});

  @override
  ConsumerState<MeetUpCreateSelectSchoolTab> createState() =>
      _MeetUpCreateSelectSchoolTabState();
}

class _MeetUpCreateSelectSchoolTabState
    extends ConsumerState<MeetUpCreateSelectSchoolTab> {
  @override
  Widget build(BuildContext context) {
    final createMeetUpState = ref.watch(createMeetUpProvider);

    void onTapIsPublic(isPublic) {
      logger.d(isPublic);
      ref.read(createMeetUpProvider.notifier).onTapIsPublic(isPublic);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'createMeetupScreen0.title'.tr(),
                style: getTsHeading20(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onTapIsPublic(false);
                      widget.controller.animateTo(1);
                    },
                    child: Container(
                      height: 172,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: createMeetUpState!.is_public == false
                            ? kColorBgElevation2
                            : kColorBgDefault,
                        // color: kColorBgDefault,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: const [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ThumbnailIconWidget(
                            size: 52,
                            iconSize: 44,
                            padding: 4,
                            isSelected: false,
                            radius: 12,
                            iconPath: kCategoryDefaultPath,
                            thumbnailIconType: ThumbnailIconType.network,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "createMeetupScreen0.private.title".tr(),
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentDefault,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "createMeetupScreen0.private.desc".tr(),
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeaker,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onTapIsPublic(true);
                      widget.controller.animateTo(1);
                    },
                    child: Container(
                      height: 172,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: createMeetUpState.is_public == true
                            ? kColorBgElevation2
                            : kColorBgDefault,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: const [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ThumbnailIconWidget(
                            size: 52,
                            iconSize: 44,
                            padding: 4,
                            isSelected: false,
                            radius: 12,
                            iconPath:
                                'https://biskit-bucket.s3.ap-northeast-2.amazonaws.com/default_icon/ic_language_exchange_fill_48.svg',
                            thumbnailIconType: ThumbnailIconType.network,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "createMeetupScreen0.public.title".tr(),
                                style: getTsBody16Sb(context).copyWith(
                                  color: kColorContentDefault,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "createMeetupScreen0.public.desc".tr(),
                                style: getTsBody14Rg(context).copyWith(
                                  color: kColorContentWeaker,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
