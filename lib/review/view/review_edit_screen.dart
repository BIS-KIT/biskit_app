import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/review/provider/review_provider.dart';
import 'package:biskit_app/review/repository/review_repository.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/model/res_review_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewEditScreen extends ConsumerStatefulWidget {
  final ResReviewModel reviewModel;
  const ReviewEditScreen({
    Key? key,
    required this.reviewModel,
  }) : super(key: key);

  @override
  ConsumerState<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends ConsumerState<ReviewEditScreen> {
  final ScrollController controller = ScrollController(
      // initialScrollOffset: 0.0,
      // keepScrollOffset: true,
      );
  String reviewStr = '';
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  PhotoModel? photoModel;
  @override
  void initState() {
    super.initState();
    reviewStr = widget.reviewModel.context;
    textEditingController.text = reviewStr;
    controller.addListener(() {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  onTapUpdateReview() async {
    final String? uploadResult = photoModel == null
        ? widget.reviewModel.image_url
        : await ref.read(utilRepositoryProvider).uploadImage(
              photo: photoModel!,
              uploadImageType: UploadImageType.REVIEW,
            );
    if (uploadResult != null) {
      final bool isOk = await ref.read(reviewRepositoryProvider).updateReview(
            reviewId: widget.reviewModel.id,
            imageUrl: uploadResult,
            context: textEditingController.text,
          );

      if (isOk) {
        final userState = ref.watch(userMeProvider);
        if (userState != null && userState is UserModel) {
          await ref.read(reviewProvider(userState.id).notifier).fetchItems(
                forceRefetch: true,
              );
        }
        if (!mounted) return;
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultLayout(
      title: '후기 수정',
      leadingIconPath: 'assets/icons/ic_cancel_line_24.svg',
      onTapLeading: () async {
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      ReviewCardWidget(
                        width: size.width - 40,
                        reviewImgType: ReviewImgType.networkImage,
                        // photoModel: widget.photoModel,
                        imagePath: widget.reviewModel.image_url,
                        isShowLogo: true,
                        isShowFlag: true,
                        flagCodeList: widget
                            .reviewModel.creator.user_nationality
                            .map((e) => e.nationality.code)
                            .toList(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: kColorBorderDefalut,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: kColorBgElevation1,
                            ),
                            child: TextFormField(
                              controller: textEditingController,
                              minLines: 5,
                              maxLines: 10,
                              maxLength: 500,
                              style: getTsBody16Rg(context).copyWith(
                                color: kColorContentWeak,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                hintText:
                                    '즐거웠던 모임 경험을 들려주세요.(선택)\n\n부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다.',
                                hintStyle: getTsBody16Rg(context).copyWith(
                                  color: kColorContentPlaceholder,
                                ),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${textEditingController.text.length}/500',
                                style: getTsCaption11Rg(context).copyWith(
                                  color: kColorContentWeakest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const Spacer(),
            Container(
              padding: const EdgeInsets.only(
                top: 12,
                left: 20,
                bottom: 20,
                right: 20,
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await onTapUpdateReview();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: FilledButtonWidget(
                  text: '후기 수정하기',
                  isEnable: textEditingController.text.isNotEmpty,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
