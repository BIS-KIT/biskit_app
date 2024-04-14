import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/setting/model/notice_model.dart';
import 'package:biskit_app/setting/provider/notice_provider.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/setting/view/write_notice_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  final NoticeModel? notice;
  final int noticeId;

  NoticeDetailScreen({
    Key? key,
    this.notice,
    int? noticeId,
  })  : noticeId = notice?.id ?? noticeId!,
        super(key: key);

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  final DateFormat dateFormat = DateFormat('yyyy.MM.dd', 'ko');
  NoticeModel? noticeDetail;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setNotice();
  }

  setNotice() async {
    if (widget.notice == null) {
      noticeDetail = await ref
          .read(settingRepositoryProvider)
          .getNotice(notice_id: widget.noticeId);
    } else {
      noticeDetail = widget.notice;
    }
    setState(() {});
  }

  getNotice() async {
    ref.read(settingRepositoryProvider).getNotice(notice_id: widget.noticeId);
  }

  deleteNotice() async {
    await ref
        .read(noticeProvider.notifier)
        .deleteNotice(noticeId: widget.noticeId, userId: noticeDetail!.user.id);
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
                  builder: (context) => WriteNoticeScreen(
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
      child: noticeDetail == null
          ? const Center(
              child: CustomLoading(),
            )
          : SingleChildScrollView(
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
                            noticeDetail!.title,
                            style: getTsHeading18(context)
                                .copyWith(color: kColorContentWeak),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            dateFormat.format(
                                DateTime.parse(noticeDetail!.created_time)),
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
                      noticeDetail!.content,
                      style: getTsBody16Rg(context)
                          .copyWith(color: kColorContentWeak),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
