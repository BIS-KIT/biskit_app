import 'package:biskit_app/common/view/photo_view_screen.dart';
import 'package:biskit_app/review/view/review_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:biskit_app/common/components/review_card_widget.dart';
import 'package:biskit_app/common/components/thumbnail_icon_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';

class ReviewViewScreen extends StatelessWidget {
  static String get routeName => 'reviewView';
  const ReviewViewScreen({
    Key? key,
  }) : super(key: key);

  void onTapMore({
    required BuildContext context,
  }) {
    showReviewMoreBottomSheet(
      context: context,
      onTapFix: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReviewEditScreen(
              imagePath:
                  'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              reviewText: 'asdf',
            ),
          ),
        );
      },
      onTapDelete: () async {
        Navigator.pop(context);
        await showConfirmModal(
          context: context,
          leftCall: () {
            Navigator.pop(context);
          },
          leftButton: '취소',
          rightCall: () {
            // TODO 삭제처리
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultLayout(
      title: '후기',
      backgroundColor: kColorBgElevation1,
      actions: [
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
            onTapMore(context: context);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // PhotoViewScreen(imageUrl: imageUrl)
              },
              child: ReviewCardWidget(
                width: size.width - 40,
                imagePath:
                    'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                reviewImgType: ReviewImgType.networkImage,
                isShowLogo: true,
                isShowFlag: true,
                flagCodeList: const [
                  'kr',
                  'us',
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
                  const ThumbnailIconWidget(
                    isCircle: false,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '모임 제목 여기에',
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
                              '10/16 (목)',
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
                              '오후 2:00',
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
                              '장소명',
                              style: getTsBody14Rg(context).copyWith(
                                color: kColorContentWeaker,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '지난 주말에 저는 Kyle과 Estelle과 성수에서 오후를 보냈습니다. 먼저 다 같이 "옹근달"이라는 아주 힙한 카페에 갔고 서로를 알게 되었습니다 (팁: 옹근달 크로아상이 정말 맛있으며 한국에서 먹어본 프랑스 크로아상에 가장 비슷한 것 같아요! 🥐)',
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
