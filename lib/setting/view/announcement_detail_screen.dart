import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/model/notice_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/setting/view/write_announcement_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnnouncementDetailScreen extends ConsumerStatefulWidget {
  final NoticeModel notice;
  const AnnouncementDetailScreen({
    Key? key,
    required this.notice,
  }) : super(key: key);

  @override
  ConsumerState<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState
    extends ConsumerState<AnnouncementDetailScreen> {
  final DateFormat dateFormat = DateFormat('yyyy.MM.dd', 'ko');
  deleteNotice() async {
    await ref.read(settingRepositoryProvider).deleteNotice(
        notice_id: widget.notice.id, user_id: widget.notice.user.id);
  }

  onTapMore() {
    showMoreBottomSheet(
      context: context,
      list: [
        MoreButton(
            text: 'modal.edit'.tr(),
            color: kColorContentDefault,
            onTap: () async {
              bool isBack = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteAnnouncementScreen(
                    isEditMode: true,
                    notice: widget.notice,
                  ),
                ),
              );
              if (isBack && mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            }),
        MoreButton(
          text: 'modal.delete'.tr(),
          color: kColorContentError,
          onTap: () {
            deleteNotice();
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return DefaultLayout(
      title: 'noticeScreen.header'.tr(),
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      actions: [
        if (userState != null && userState is UserModel && userState.is_admin)
          GestureDetector(
            onTap: () {
              onTapMore();
            },
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/icons/ic_more_horiz_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
      ],
      backgroundColor: kColorBgElevation1,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: kColorBorderDefalut,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notice.title,
                      style: getTsHeading18(context)
                          .copyWith(color: kColorContentWeak),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dateFormat
                          .format(DateTime.parse(widget.notice.created_time)),
                      style: getTsBody14Rg(context)
                          .copyWith(color: kColorContentWeakest),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.notice.content,
                style:
                    getTsBody16Rg(context).copyWith(color: kColorContentWeak),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
