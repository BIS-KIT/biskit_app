import 'package:biskit_app/common/components/review_card_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/meet/model/meet_up_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/photo_manager_screen.dart';

class ReviewWriteScreen extends StatefulWidget {
  final PhotoModel photoModel;
  final MeetUpModel meetUpModel;
  const ReviewWriteScreen({
    Key? key,
    required this.photoModel,
    required this.meetUpModel,
  }) : super(key: key);

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  final ScrollController controller = ScrollController(
      // initialScrollOffset: 0.0,
      // keepScrollOffset: true,
      );
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultLayout(
      title: '후기 작성',
      leadingIconPath: 'assets/icons/ic_cancel_line_24.svg',
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
                        reviewImgType: ReviewImgType.photoModel,
                        photoModel: widget.photoModel,
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
                              maxLines: 5,
                              maxLength: 300,
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
                                '0/500',
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
                text: '후기 남기기',
                isEnable: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
