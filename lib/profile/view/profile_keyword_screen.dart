// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/profile/model/Introduction_create_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/profile/components/keyword_input_widget.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:go_router/go_router.dart';

class ProfileKeywordScreen extends StatefulWidget {
  static String get routeName => 'profileKeyword';
  final ProfileCreateModel? profileCreateModel;
  const ProfileKeywordScreen({
    Key? key,
    this.profileCreateModel,
  }) : super(key: key);

  @override
  State<ProfileKeywordScreen> createState() => _ProfileKeywordScreenState();
}

class _ProfileKeywordScreenState extends State<ProfileKeywordScreen> {
  final List<KeywordModel> keywordList = [];

  void onTapKeywordDelete(int index) {
    showConfirmModal(
      context: context,
      leftCall: () {
        Navigator.pop(context);
      },
      rightCall: () {
        setState(() {
          keywordList.removeAt(index - 1);
        });
        Navigator.pop(context);
      },
      title: '삭제하시겠어요?',
    );
  }

  onTapNext() {
    if (keywordList.isNotEmpty) {
      context.pushNamed(
        ProfileIdConfirmScreen.routeName,
        extra: widget.profileCreateModel!.copyWith(
            introductions: List.from(
          keywordList.map(
            (e) => IntroductionCreateModel(
              keyword: e.keyword,
              context: e.reason,
            ),
          ),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              '3 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '딱딱한비스킷님,\n좋아하는 것을 알려주세요',
                  style: getTsHeading24(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '비슷한 취향을 가진 친구를 만날 수 있어요',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorContentWeaker,
                  ),
                ),
              ],
            ),
          ),

          // keyword
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 360,
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return keywordList.length == 5
                                ? Container()
                                : _buildAddCard();
                          } else {
                            return _buildKeywordCard(index, context);
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 12,
                        ),
                        itemCount: keywordList.length + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const Spacer(),

          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 34,
            ),
            child: GestureDetector(
              onTap: onTapNext,
              child: FilledButtonWidget(
                text: '다음',
                isEnable: keywordList.isNotEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildKeywordCard(int index, BuildContext context) {
    return Container(
      width: 270,
      height: 360,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kColorBgInverse,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  keywordList[index - 1].keyword,
                  style: getTsBody16Sb(context).copyWith(
                    color: kColorBgDefault,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              GestureDetector(
                onTap: () {
                  onTapKeywordDelete(index);
                },
                child: SvgPicture.asset(
                  'assets/icons/ic_cancel_line_24.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    kColorContentWeaker,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            thickness: 1,
            color: kColorBorderOnBgInverse,
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                keywordList[index - 1].reason,
                style: getTsBody14Rg(context).copyWith(
                  color: kColorBgElevation1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () async {
        final result = await showBiskitBottomSheet(
          context: context,
          title: '키워드 작성',
          rightIcon: 'assets/icons/ic_cancel_line_24.svg',
          onRightTap: () => Navigator.pop(context),
          isDismissible: false,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              44,
          contentWidget: const KeywordInputWidget(),
        );
        logger.d(result);
        if (result != null) {
          KeywordModel keywordModel = KeywordModel(
            keyword: result['keyword'],
            reason: result['reason'],
          );
          setState(() {
            keywordList.insert(0, keywordModel);
          });
        }
      },
      child: Container(
        width: 270,
        height: 360,
        decoration: BoxDecoration(
          color: kColorBgElevation1,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 1,
            color: kColorBgElevation3,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_plus_line_24.svg',
              width: 40,
              height: 40,
              colorFilter: const ColorFilter.mode(
                kColorContentDisabled,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeywordModel {
  final String keyword;
  final String reason;
  KeywordModel({
    required this.keyword,
    required this.reason,
  });
}
