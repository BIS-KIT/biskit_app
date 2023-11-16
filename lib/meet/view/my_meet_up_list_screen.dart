import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/cursor_pagination_model.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/meet/components/meet_up_card_widget.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/profile/provider/profile_meeting_provider.dart';
import 'package:biskit_app/review/view/review_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyMeetUpListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'myMeetUpList';
  const MyMeetUpListScreen({super.key});

  @override
  ConsumerState<MyMeetUpListScreen> createState() => _MyMeetUpListScreenState();
}

class _MyMeetUpListScreenState extends ConsumerState<MyMeetUpListScreen> {
  final ScrollController scrollController = ScrollController();
  List<MeetUpModel> list = [];
  bool isLoading = false;
  int skip = 0;
  final int limit = 20;
  int totalCount = 0;
  bool hasMore = true;

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
  }

  init() async {
    await fetchItems();
  }

  fetchItems() async {
    if (!hasMore) return;
    setState(() {
      isLoading = true;
    });

    final CursorPagination<MeetUpModel>? cursorPagination =
        await ref.read(profileMeetingProvider.notifier).getMyMeeting(
              skip: skip,
              limit: limit,
            );
    if (cursorPagination != null) {
      list = [
        ...list,
        ...cursorPagination.data,
      ];
      totalCount = cursorPagination.meta.totalCount;
      skip = list.length;
      hasMore = cursorPagination.meta.hasMore;
    } else {
      list = [];
      totalCount = 0;
      skip = 0;
      hasMore = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  onTapMeetUpCard(MeetUpModel model) async {
    final List<PhotoModel> result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhotoManagerScreen(
          isCamera: true,
          maxCnt: 1,
        ),
      ),
    );
    if (!mounted) return;
    if (result.isNotEmpty) {
      // 후기 작성 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewWriteScreen(
            photoModel: result[0],
            meetUpModel: model,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBgElevation2,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 10,
                    bottom: 2,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icons/ic_arrow_back_ios_line_24.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              kColorContentDefault,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 20,
                    bottom: 8,
                    right: 20,
                  ),
                  child: Text(
                    '어떤 모임의\n인증샷을 남길까요?',
                    style: getTsHeading20(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CustomLoading(),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      itemBuilder: (context, index) => MeetUpCardWidget(
                        model: list[index],
                        onTapMeetUp: () {
                          onTapMeetUpCard(list[index]);
                        },
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                      itemCount: list.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
