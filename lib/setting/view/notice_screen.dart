import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/notice_list_model.dart';
import 'package:biskit_app/setting/provider/notice_provider.dart';
import 'package:biskit_app/setting/view/notice_detail_screen.dart';
import 'package:biskit_app/setting/view/write_notice_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'notice';

  const NoticeScreen({super.key});

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  final DateFormat dateFormat = DateFormat('yyyy.MM.dd', 'ko');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeProvider);
    final userState = ref.read(userMeProvider);
    return DefaultLayout(
      title: 'noticeScreen.header'.tr(),
      shape: const Border(
        bottom: BorderSide(
          width: 1,
          color: kColorBorderDefalut,
        ),
      ),
      actions: [
        if (userState is UserModel && userState.is_admin)
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WriteNoticeScreen(),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/icons/ic_plus_line_24.svg',
                width: 24,
                height: 24,
              ),
            ),
          )
        else
          Container(),
      ],
      child: noticeState == null
          ? Center(
              child: Text(
                'noticeScreen.noNotice'.tr(),
                style: getTsBody16Sb(context)
                    .copyWith(color: kColorContentWeakest),
              ),
            )
          : noticeState is NoticeListModel
              ? ListView.builder(
                  itemCount: noticeState.notices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: kColorBorderWeak,
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticeDetailScreen(
                                notice: noticeState.notices[index],
                              ),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      noticeState.notices[index].title,
                                      style: getTsBody16Rg(context)
                                          .copyWith(color: kColorContentWeak),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      dateFormat.format(DateTime.parse(
                                          noticeState
                                              .notices[index].created_time)),
                                      style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeakest),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SvgPicture.asset(
                                'assets/icons/ic_chevron_right_line_24.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  kColorContentWeakest,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'noticeScreen.noNotice'.tr(),
                    style: getTsBody16Sb(context)
                        .copyWith(color: kColorContentWeakest),
                  ),
                ),
    );
  }
}
