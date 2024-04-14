// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/level_bar_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/profile/components/lang_level_list_widget.dart';
import 'package:biskit_app/profile/components/lang_list_widget.dart';
import 'package:biskit_app/profile/model/available_language_create_model.dart';
import 'package:biskit_app/profile/model/profile_create_model.dart';
import 'package:biskit_app/profile/model/use_language_model.dart';
import 'package:biskit_app/profile/provider/use_language_provider.dart';
import 'package:biskit_app/profile/view/profile_keyword_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfileLanguageScreen extends ConsumerStatefulWidget {
  static String get routeName => 'profileLanguage';

  final ProfileCreateModel? profileCreateModel;
  const ProfileLanguageScreen({
    super.key,
    this.profileCreateModel,
  });

  @override
  ConsumerState<ProfileLanguageScreen> createState() =>
      _ProfileLanguageScreenState();
}

class _ProfileLanguageScreenState extends ConsumerState<ProfileLanguageScreen> {
  List<UseLanguageModel> selectedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 레벨선택
  onTapSelectedLevel(UseLanguageModel useLanguage) {
    FocusScope.of(context).unfocus();
    showDefaultModalBottomSheet(
      context: context,
      title: 'langLevelBottomSheet.title'.tr(),
      titleRightButton: true,
      enableDrag: false,
      isDismissible: false,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          200,
      contentWidget: LangLevelListWidget(
        level: useLanguage.level,
        callback: (level) {
          ref
              .read(useLanguageProvider.notifier)
              .setLevel(useLanguage: useLanguage, level: level);
        },
      ),
    );
  }

  // 언어선택
  onTapSelectedLang() {
    showDefaultModalBottomSheet(
      context: context,
      title: 'selectLangBottomSheet.title'.tr(),
      titleRightButton: true,
      enableDrag: false,
      isDismissible: false,
      contentWidget: LangListWidget(callback: () {
        List<UseLanguageModel> tempList =
            ref.read(useLanguageProvider.notifier).getSelectedList();

        setState(() {
          selectedList = tempList;
        });
        Navigator.pop(context);
      }),
    );
  }

  onTapNext() {
    if (selectedList.isEmpty || widget.profileCreateModel == null) return;

    context.pushNamed(
      ProfileKeywordScreen.routeName,
      extra: widget.profileCreateModel!.copyWith(
          available_languages: List.from(
        selectedList.map(
          (e) => AvailableLanguageCreateModel(
            level: getLevelServerValue(e.level),
            language_id: e.languageModel.id,
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UseLanguageModel> sortedSelectedList = List.from(selectedList)
      ..sort((a, b) {
        // 먼저 level로 내림차순 정렬
        int levelComparison = b.level.compareTo(a.level);

        // level이 같은 경우 kr_name으로 오름차순 정렬
        return levelComparison != 0
            ? levelComparison
            : a.languageModel.kr_name.compareTo(b.languageModel.kr_name);
      });

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
              '2 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorContentWeakest,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'availableLangScreen.title'.tr(),
                    style: getTsHeading24(context).copyWith(
                      color: kColorContentDefault,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  if (selectedList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          ...sortedSelectedList
                              .map((e) => _buildLangTile(e, context))
                              .toList()
                        ],
                      ),
                    ),
                  if (selectedList.length < 5)
                    GestureDetector(
                      onTap: onTapSelectedLang,
                      child: OutlinedButtonWidget(
                        text: 'availableLangScreen.selectLang'.tr(),
                        height: 52,
                        isEnable: true,
                        leftIconPath: 'assets/icons/ic_plus_line_24.svg',
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 34,
            ),
            child: GestureDetector(
              onTap: onTapNext,
              child: FilledButtonWidget(
                text: 'availableLangScreen.next'.tr(),
                fontSize: FontSize.l,
                height: 56,
                isEnable: selectedList.isNotEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLangTile(UseLanguageModel e, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 8,
        left: 16,
      ),
      height: 52,
      decoration: const BoxDecoration(
        color: kColorBgElevation1,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onTapSelectedLang();
              },
              child: Row(
                children: [
                  Text(
                    context.locale.languageCode == 'en'
                        ? e.languageModel.en_name
                        : e.languageModel.kr_name,
                    style: getTsBody16Sb(context).copyWith(
                      color: kColorContentWeak,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    getLevelTitle(e.level),
                    style: getTsBody16Sb(context).copyWith(
                      color: kColorContentSecondary,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  LevelBarWidget(level: e.level),
                  const Spacer(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedList.removeWhere((element) => element == e);
              });
              ref.read(useLanguageProvider.notifier).deleteLang(e);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/ic_cancel_line_24.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  kColorContentWeakest,
                  BlendMode.srcIn,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
