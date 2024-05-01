// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/profile/components/keyword_input_widget.dart';
import 'package:biskit_app/profile/model/Introduction_create_model.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/view/profile_id_confirm_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfileKeywordScreen extends StatefulWidget {
  static String get routeName => 'profileKeyword';
  final ProfileCreateModel? profileCreateModel;
  final bool isEditorMode;
  final Function(List<KeywordModel> keywordList)? editorCallback;
  final List<KeywordModel>? introductions;
  final String? userNickName;
  const ProfileKeywordScreen({
    Key? key,
    this.profileCreateModel,
    this.isEditorMode = false,
    this.editorCallback,
    this.introductions,
    this.userNickName,
  }) : super(key: key);

  @override
  State<ProfileKeywordScreen> createState() => _ProfileKeywordScreenState();
}

class _ProfileKeywordScreenState extends State<ProfileKeywordScreen> {
  List<KeywordModel> keywordList = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    if (widget.isEditorMode) {
      setState(() {
        keywordList = [...widget.introductions!];
        // keywordList = List<KeywordModel>.from(
        //   widget.introductions!
        //       .map(
        //         (e) => KeywordModel(
        //           keyword: e.keyword,
        //           context: e.context,
        //         ),
        //       )
        //       .toList(),
        // );
      });
    }
  }

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
      rightBackgroundColor: kColorBgError,
      rightTextColor: kColorContentError,
      rightButton: 'deleteKeywordModal.delete'.tr(),
      leftButton: 'deleteKeywordModal.cancel'.tr(),
      title: 'deleteKeywordModal.title'.tr(),
    );
  }

  onTapNext() {
    if (keywordList.isNotEmpty) {
      if (widget.isEditorMode) {
        widget.editorCallback!(keywordList);
      } else {
        // 회원가입 진행
        context.pushNamed(
          ProfileIdConfirmScreen.routeName,
          extra: widget.profileCreateModel!.copyWith(
              introductions: List.from(
            keywordList.map(
              (e) => IntroductionCreateModel(
                keyword: e.keyword,
                context: e.context,
              ),
            ),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      leadingIconPath: widget.isEditorMode
          ? 'assets/icons/ic_cancel_line_24.svg'
          : 'assets/icons/ic_arrow_back_ios_line_24.svg',
      actions: [
        if (!widget.isEditorMode)
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
                  '${context.locale.languageCode == 'en' ? 'Welcome ' : ''} ${widget.isEditorMode ? widget.userNickName ?? '' : widget.profileCreateModel!.nick_name}${'addKeywordScreen.title'.tr()}',
                  style: getTsHeading24(context).copyWith(
                    color: kColorContentDefault,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'addKeywordScreen.subtitle'.tr(),
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
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 362,
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
                        separatorBuilder: (context, index) {
                          if (keywordList.length == 5 && index == 0) {
                            return Container();
                          }
                          return const SizedBox(
                            width: 12,
                          );
                        },
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
                text: widget.isEditorMode
                    ? 'addKeywordScreen.save'.tr()
                    : 'addKeywordScreen.next'.tr(),
                fontSize: FontSize.l,
                isEnable: keywordList.isNotEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordCard(int index, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showBiskitBottomSheet(
          context: context,
          title: 'addKeywordBottomSheet.title'.tr(),
          rightIcon: 'assets/icons/ic_cancel_line_24.svg',
          onRightTap: () => Navigator.pop(context),
          isDismissible: false,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              44,
          contentWidget: KeywordInputWidget(
            keyword: keywordList[index - 1].keyword,
            context: keywordList[index - 1].context,
          ),
        );
        logger.d(result);
        if (result != null) {
          KeywordModel keywordModel = KeywordModel(
            keyword: result['keyword'],
            context: result['context'],
          );
          setState(() {
            keywordList[index - 1] = keywordModel;
          });
        }
      },
      child: Container(
        width: 270,
        height: 360,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: kColorBgInverseWeak,
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
                      color: kColorContentInverse,
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
                      kColorContentWeakest,
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
              height: 1,
              color: kColorBorderOnBgInverse,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  keywordList[index - 1].context,
                  style: getTsBody14Rg(context).copyWith(
                    color: kColorContentInverseWeak,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () async {
        final result = await showBiskitBottomSheet(
          context: context,
          title: 'addKeywordBottomSheet.title'.tr(),
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
            context: result['context'],
          );
          setState(() {
            keywordList.insert(0, keywordModel);
          });
        }
      },
      child: Container(
        width: 270,
        height: 360,
        // padding: const EdgeInsets.symmetric(vertical: 160),
        decoration: BoxDecoration(
          color: kColorBgElevation1,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 1,
            color: kColorBorderDefalut,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 160,
            ),
            SizedBox(
              height: 40,
              child: SvgPicture.asset(
                'assets/icons/ic_plus_line_24.svg',
                width: 40,
                height: 40,
                alignment: Alignment.center,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeakest,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Container(
              height: 160,
            ),
          ],
        ),
      ),
    );
  }
}

class KeywordModel {
  final String keyword;
  final String context;
  KeywordModel({
    required this.keyword,
    required this.context,
  });

  KeywordModel copyWith({
    String? keyword,
    String? context,
  }) {
    return KeywordModel(
      keyword: keyword ?? this.keyword,
      context: context ?? this.context,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keyword': keyword,
      'context': context,
    };
  }

  factory KeywordModel.fromMap(Map<String, dynamic> map) {
    return KeywordModel(
      keyword: map['keyword'] ?? '',
      context: map['context'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KeywordModel.fromJson(String source) =>
      KeywordModel.fromMap(json.decode(source));

  @override
  String toString() => 'KeywordModel(keyword: $keyword, context: $context)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeywordModel &&
        other.keyword == keyword &&
        other.context == context;
  }

  @override
  int get hashCode => keyword.hashCode ^ context.hashCode;
}
