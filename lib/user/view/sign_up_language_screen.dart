import 'package:biskit_app/common/component/lang_level_list_widget.dart';
import 'package:biskit_app/common/component/lang_list_widget.dart';
import 'package:biskit_app/common/component/level_bar_widget.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/string_util.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpLanguageScreen extends ConsumerStatefulWidget {
  const SignUpLanguageScreen({super.key});

  @override
  ConsumerState<SignUpLanguageScreen> createState() =>
      _SignUpLanguageScreenState();
}

class _SignUpLanguageScreenState extends ConsumerState<SignUpLanguageScreen> {
  List<UseLanguage> selectedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 레벨선택
  onTapSelectedLevel(UseLanguage useLanguage) {
    FocusScope.of(context).unfocus();
    showDefaultModalBottomSheet(
      context: context,
      title: '레벨 선택',
      titleRightButton: true,
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
      title: '언어 선택',
      titleRightButton: true,
      contentWidget: LangListWidget(callback: () {
        List<UseLanguage> tempList =
            ref.read(useLanguageProvider.notifier).getSelectedList();

        setState(() {
          selectedList = tempList;
        });
        Navigator.pop(context);
      }),
    );
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
              '2 / 4',
              style: getTsBody14Rg(context).copyWith(
                color: kColorGray6,
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
                    '사용가능한 언어를\n알려주세요',
                    style: getTsHeading24(context).copyWith(
                      color: kColorGray9,
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
                          ...selectedList
                              .map((e) => _buildLangTile(e, context))
                              .toList()
                        ],
                      ),
                    ),
                  if (selectedList.length < 5)
                    GestureDetector(
                      onTap: onTapSelectedLang,
                      child: const OutlinedButtonWidget(
                        text: '언어선택',
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
              child: FilledButtonWidget(
                text: '다음',
                isEnable: selectedList.isNotEmpty,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLangTile(UseLanguage e, BuildContext context) {
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
        color: kColorGray1,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Text(
            e.langName,
            style: getTsBody16Sb(context).copyWith(
              color: kColorGray8,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            getLevelTitle(e.level),
            style: getTsBody16Sb(context).copyWith(
              color: kColorBlue3,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          LevelBarWidget(level: e.level),
          const Spacer(),
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
                  kColorGray6,
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

final useLanguageProvider =
    StateNotifierProvider<UseLanguageStateNotifier, List<UseLanguage>?>((ref) {
  return UseLanguageStateNotifier();
});

// TODO 임시 클래스
class UseLanguageStateNotifier extends StateNotifier<List<UseLanguage>?> {
  UseLanguageStateNotifier() : super(null) {
    getList();
  }

  getList() async {
    await Future.delayed(const Duration(seconds: 3));
    logger.d('getList');
    state = [
      UseLanguage(langName: '한국어', level: 0, isChecked: false),
      UseLanguage(langName: '영어', level: 0, isChecked: false),
      UseLanguage(langName: '중국어', level: 0, isChecked: false),
      UseLanguage(langName: '일본어', level: 0, isChecked: false),
      UseLanguage(langName: '스페인어', level: 0, isChecked: false),
      UseLanguage(langName: '프랑스어', level: 0, isChecked: false),
      UseLanguage(langName: '러시아어', level: 0, isChecked: false),
      UseLanguage(langName: '아랍어', level: 0, isChecked: false),
      UseLanguage(langName: '안녕어', level: 0, isChecked: false),
      UseLanguage(langName: '유럽어', level: 0, isChecked: false),
      UseLanguage(langName: '외계인어', level: 0, isChecked: false),
      UseLanguage(langName: '애니어', level: 0, isChecked: false),
      UseLanguage(langName: '밈어', level: 0, isChecked: false),
      UseLanguage(langName: '껨어', level: 0, isChecked: false),
    ];
  }

  toggleLang(UseLanguage useLanguage) {
    if (state != null) {
      state = state!
          .map((e) => e == useLanguage
              ? e.copyWith(
                  isChecked: !e.isChecked,
                  level: e.isChecked ? 0 : e.level,
                )
              : e)
          .toList();
    }
  }

  setLevel({
    required UseLanguage useLanguage,
    required int level,
  }) {
    if (state != null) {
      state = state!
          .map((e) => e.langName == useLanguage.langName
              ? e.copyWith(
                  level: level,
                )
              : e)
          .toList();
    }
  }

  List<UseLanguage> getSelectedList() {
    return state != null
        ? state!.where((element) => element.isChecked).toList()
        : [];
  }

  void deleteLang(UseLanguage useLanguage) {
    if (state != null) {
      state = state!
          .map((e) => e == useLanguage
              ? e.copyWith(
                  isChecked: false,
                  level: 0,
                )
              : e)
          .toList();
    }
  }
}

class UseLanguage {
  final String langName;
  final int level;
  final bool isChecked;
  UseLanguage({
    required this.langName,
    required this.level,
    required this.isChecked,
  });

  UseLanguage copyWith({
    String? langName,
    int? level,
    bool? isChecked,
  }) {
    return UseLanguage(
      langName: langName ?? this.langName,
      level: level ?? this.level,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
