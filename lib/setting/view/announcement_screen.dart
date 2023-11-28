import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/setting/model/notice_list_model.dart';
import 'package:biskit_app/setting/repository/setting_repository.dart';
import 'package:biskit_app/setting/view/announcement_detail_screen.dart';
import 'package:biskit_app/setting/view/write_announcement_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnnouncementScreen extends ConsumerStatefulWidget {
  static String get routeName => 'announcement';

  const AnnouncementScreen({super.key});

  @override
  ConsumerState<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen> {
  NoticeListModel? noticeData;
  final DateFormat dateFormat = DateFormat('yyyy.MM.dd', 'ko');

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    NoticeListModel? res =
        await ref.read(settingRepositoryProvider).getNoticeList();
    setState(() {
      noticeData = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = (ref.watch(userMeProvider) as UserModel).is_admin;
    if (noticeData == null) {
      init();
    }
    return DefaultLayout(
        title: '공지사항',
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        actions: [
          if (isAdmin)
            GestureDetector(
              onTap: () async {
                final bool? refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WriteAnnouncementScreen(),
                  ),
                );
                if (refresh == true) {
                  init();
                }
              },
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
        child: noticeData == null
            ? const Center(
                child: CustomLoading(),
              )
            : ListView.builder(
                itemCount: noticeData!.notices.length,
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
                        final bool? refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementDetailScreen(
                              notice: noticeData!.notices[index],
                            ),
                          ),
                        );
                        if (refresh == true) {
                          init();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    noticeData!.notices[index].title,
                                    style: getTsBody16Rg(context)
                                        .copyWith(color: kColorContentWeak),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    dateFormat.format(DateTime.parse(noticeData!
                                        .notices[index].created_time)),
                                    style: getTsBody14Rg(context)
                                        .copyWith(color: kColorContentWeakest),
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
              ));
  }
}
