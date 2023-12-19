import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/setting/view/report_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/data.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_view_screen.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/meet/view/meet_up_detail_screen.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:biskit_app/review/provider/review_provider.dart';
import 'package:biskit_app/review/repository/review_repository.dart';
import 'package:biskit_app/review/view/review_edit_screen.dart';

class ReviewViewScreen extends ConsumerStatefulWidget {
  static String get routeName => 'reviewView';
  final ResReviewModel? model;
  final int? id;
  const ReviewViewScreen({
    Key? key,
    this.model,
    this.id,
  }) : super(key: key);

  @override
  ConsumerState<ReviewViewScreen> createState() => _ReviewViewScreenState();
}

class _ReviewViewScreenState extends ConsumerState<ReviewViewScreen> {
  final DateFormat dateFormat1 = DateFormat('MM/dd(EEE)', 'ko');
  final DateFormat dateFormat2 = DateFormat('a h:mm', 'ko');
  MeetUpModel? meetUpModel;
  ResReviewModel? resReviewModel;
  UserModelBase? userState;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.id != null) {
      resReviewModel =
          await ref.read(reviewRepositoryProvider).getReview(widget.id!);
    } else {
      logger.d(widget.model);
      resReviewModel = widget.model;
    }
    meetUpModel = await ref
        .read(meetUpRepositoryProvider)
        .getMeeting(resReviewModel!.meeting_id);
    setState(() {});
  }

  onTapMeetUpCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetUpDetailScreen(meetUpModel: meetUpModel!),
      ),
    );
  }

  void onTapMore() {
    if (userState != null && userState is UserModel) {
      if ((userState as UserModel).id == resReviewModel!.creator.id) {
        final reviewId = resReviewModel!.id;
        // 작성자 모어 버튼
        showReviewMoreBottomSheet(
          context: context,
          onTapFix: () async {
            Navigator.pop(context);
            final isOk = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewEditScreen(
                  reviewModel: resReviewModel!,
                ),
              ),
            );
            if (isOk) {
              resReviewModel =
                  await ref.read(reviewRepositoryProvider).getReview(reviewId);
              setState(() {});
            }
          },
          onTapDelete: () async {
            Navigator.pop(context);
            await showConfirmModal(
              context: context,
              leftCall: () {
                Navigator.pop(context);
              },
              leftButton: '취소',
              rightCall: () async {
                if (resReviewModel == null) return;
                await ref.read(reviewProvider(null).notifier).deleteReview(
                      id: resReviewModel!.id,
                    );
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pop(context, [true]);
              },
              rightButton: '삭제',
              rightBackgroundColor: kColorBgError,
              rightTextColor: kColorContentError,
              title: '모임 후기를 삭제하시겠어요?',
              content: '삭제한 후기는 복구할 수 없어요',
            );
          },
        );
      } else {
        // 다른 사람이 모어 버튼
        showMoreBottomSheet(
          context: context,
          list: [
            MoreButton(
              text: '신고하기',
              color: kColorContentError,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportScreen(
                      contentType: ReportContentType.Review,
                      contentId: resReviewModel!.id,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userState = ref.watch(userMeProvider);
    final size = MediaQuery.of(context).size;
    return DefaultLayout(
      title: '후기',
      backgroundColor: kColorBgElevation1,
      actions: [
        if (resReviewModel != null &&
            userState != null &&
            userState is UserModel &&
            (userState as UserModel).id == resReviewModel!.creator.id)
          Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/ic_ios_share_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentDefault,
                BlendMode.srcIn,
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            onTapMore();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/ic_more_horiz_line_24.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                kColorContentDefault,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 8,
          left: 20,
          right: 20,
        ),
        child: resReviewModel == null
            ? const Center(
                child: CustomLoading(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (resReviewModel!.image_url.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewScreen(
                            imageUrl: resReviewModel!.image_url,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: '$kReviewTagName/${resReviewModel!.id}',
                      child: ReviewCardWidget(
                        width: size.width - 40,
                        imagePath: resReviewModel!.image_url,
                        reviewImgType: ReviewImgType.networkImage,
                        isShowLogo: true,
                        isShowFlag: true,
                        flagCodeList: resReviewModel!.creator.user_nationality
                            .map((e) => e.nationality.code)
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (meetUpModel != null)
                    GestureDetector(
                      onTap: () {
                        onTapMeetUpCard();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: kColorBgDefault,
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
                        child: Row(
                          children: [
                            ThumbnailIconWidget(
                              size: 40,
                              isSelected: false,
                              radius: 8,
                              iconSize: 32,
                              padding: 4,
                              iconPath: meetUpModel!.image_url ??
                                  kCategoryDefaultPath,
                              thumbnailIconType: ThumbnailIconType.network,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    meetUpModel!.name,
                                    style: getTsBody14Sb(context).copyWith(
                                      color: kColorContentDefault,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        meetUpModel!.meeting_time.isEmpty
                                            ? ''
                                            : dateFormat1.format(DateTime.parse(
                                                meetUpModel!.meeting_time)),
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeaker,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '·',
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        meetUpModel!.meeting_time.isEmpty
                                            ? ''
                                            : dateFormat2.format(DateTime.parse(
                                                meetUpModel!.meeting_time)),
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeaker,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '·',
                                        style: getTsBody14Rg(context).copyWith(
                                          color: kColorContentWeakest,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          meetUpModel!.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              getTsBody14Rg(context).copyWith(
                                            color: kColorContentWeaker,
                                          ),
                                        ),
                                      ),
                                    ],
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    resReviewModel!.context,
                    style: getTsBody16Rg(context).copyWith(
                      color: kColorContentWeaker,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
