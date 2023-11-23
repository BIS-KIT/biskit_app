import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/review/components/review_card_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';

class ReviewEditScreen extends StatefulWidget {
  final String imagePath;
  final String reviewText;
  // final MeetUpModel meetUpModel;
  const ReviewEditScreen({
    Key? key,
    required this.imagePath,
    required this.reviewText,
  }) : super(key: key);

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  final ScrollController controller = ScrollController(
      // initialScrollOffset: 0.0,
      // keepScrollOffset: true,
      );
  String reviewStr = '';
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    reviewStr = widget.reviewText;
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
                        imagePath: widget.imagePath,
                        isShowLogo: true,
                        isShowFlag: true,
                        flagCodeList: const [
                          'kr',
                          'us',
                        ],
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
                                hintText: '즐거웠던 모임 경험을 들려주세요 (선택사항)',
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
              child: const FilledButtonWidget(
                text: '후기 수정하기',
                isEnable: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
