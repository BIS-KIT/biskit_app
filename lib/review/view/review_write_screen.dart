import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/enums.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:biskit_app/meet/repository/meet_up_repository.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/review/provider/review_provider.dart';
import 'package:biskit_app/review/view/review_view_screen.dart';
import 'package:biskit_app/user/model/user_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReviewWriteScreen extends ConsumerStatefulWidget {
  final PhotoModel? photoModel;
  final MeetUpModel meetUpModel;

  const ReviewWriteScreen({
    Key? key,
    required this.meetUpModel,
    this.photoModel,
  }) : super(key: key);

  @override
  ConsumerState<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends ConsumerState<ReviewWriteScreen> {
  final ScrollController controller = ScrollController(
      // initialScrollOffset: 0.0,
      // keepScrollOffset: true,
      );
  String reviewStr = '';
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userState = ref.watch(userMeProvider);
    return DefaultLayout(
      title: 'writeReviewScreen.title'.tr(),
      leadingIconPath: 'assets/icons/ic_cancel_line_24.svg',
      onTapLeading: () async {
        await showConfirmModal(
          context: context,
          leftCall: () {
            Navigator.pop(context);
          },
          leftButton: 'writeReviewScreen.leavePageModal.cancel'.tr(),
          rightCall: () {
            Navigator.pop(context);
            Navigator.pop(context, [true]);
          },
          rightButton: 'writeReviewScreen.leavePageModal.leave'.tr(),
          rightBackgroundColor: kColorBgError,
          rightTextColor: kColorContentError,
          title: 'writeReviewScreen.leavePageModal.title'.tr(),
          content: 'writeReviewScreen.leavePageModal.subtitle'.tr(),
        );
      },
      child: userState != null && userState is UserModel
          ? SafeArea(
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
                              reviewImgType: ReviewImgType.photoModel,
                              photoModel: widget.photoModel,
                              isShowLogo: true,
                              isShowFlag: true,
                              flagCodeList: (userState)
                                  .user_nationality
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
                                          'writeReviewScreen.placeholder'.tr(),
                                      hintStyle:
                                          getTsBody16Rg(context).copyWith(
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
                        await onTapCreateReview();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: FilledButtonWidget(
                        text: 'writeReviewScreen.done'.tr(),
                        isEnable: !isLoading,
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(),
    );
  }

  onTapCreateReview() async {
    final String? uploadResult =
        await ref.read(utilRepositoryProvider).uploadImage(
              photo: widget.photoModel!,
              uploadImageType: UploadImageType.REVIEW,
            );
    if (uploadResult != null) {
      final int? createId =
          await ref.read(meetUpRepositoryProvider).createReview(
                meetingId: widget.meetUpModel.id,
                imageUrl: uploadResult,
                context: textEditingController.text,
              );
      logger.d(createId);
      if (createId != null) {
        final userState = ref.watch(userMeProvider);
        if (userState != null && userState is UserModel) {
          ref.read(reviewProvider(userState.id).notifier).fetchItems(
                forceRefetch: true,
              );
        }
        if (!mounted) return;
        context.goNamed(
          ReviewViewScreen.routeName,
          extra: createId,
        );
      }
    }
  }
}
