import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biskit_app/common/component/custom_loading.dart';
import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/lang_level_list_widget.dart';
import 'package:biskit_app/common/component/list_tile_check_widget.dart';
import 'package:biskit_app/common/component/search_bar_widget.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/view/sign_up_language_screen.dart';

class LangListWidget extends ConsumerStatefulWidget {
  final Function() callback;
  const LangListWidget({
    super.key,
    required this.callback,
  });

  @override
  ConsumerState<LangListWidget> createState() => _LangListWidgetState();
}

class _LangListWidgetState extends ConsumerState<LangListWidget> {
  late TextEditingController searchBarController;
  String searchText = '';
  final int maxLang = 5;

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController()
      ..addListener(() {
        setState(() {
          searchText = searchBarController.text;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(useLanguageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SearchBarWidget(
            controller: searchBarController,
            onChanged: (value) {},
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: state == null
                ? const CustomLoading()
                : SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Builder(builder: (context) {
                      final List<UseLanguage> viewList = searchText.isEmpty
                          ? state
                          : state
                              .where((element) => element.langName
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                              .toList();
                      return Column(
                        children: [
                          ...viewList
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    onTapLang(e);
                                  },
                                  child: ListTileCheckWidget(
                                    text: e.langName,
                                    isChkecked: e.isChecked,
                                    isLevelView: true,
                                    level: e.level,
                                    onTapLevel: () {
                                      onTapSelectedLevel(e);
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      );
                    }),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 34,
            ),
            child: GestureDetector(
              onTap: () {
                if (state != null &&
                    (state.where((element) => element.isChecked).isNotEmpty &&
                        state.where((element) => element.isChecked).length ==
                            state
                                .where((element) => element.isChecked)
                                .where((element) => element.level > 0)
                                .length)) {
                  // 등록 처리
                  widget.callback();
                  // List<UseLanguage> tempList = ref
                  //     .read(useLanguageProvider.notifier)
                  //     .getSelectedList();

                  // setState(() {
                  //   selectedList = tempList;
                  // });
                  // Navigator.pop(context);
                }
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable: state != null &&
                    (state.where((element) => element.isChecked).isNotEmpty &&
                        state.where((element) => element.isChecked).length ==
                            state
                                .where((element) => element.isChecked)
                                .where((element) => element.level > 0)
                                .length),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTapLang(UseLanguage e) {
    final state = ref.watch(useLanguageProvider);
    // true 체크 할때 5개 제한
    if (state!.where((element) => element.isChecked).length >= maxLang &&
        e.isChecked == false) {
      showDefaultModal(
        context: context,
        title: '$maxLang개까지 선택할 수 있어요',
        buttonText: '확인',
        function: () {
          Navigator.pop(context);
        },
      );
      return;
    }
    ref.read(useLanguageProvider.notifier).toggleLang(e);
    if (!e.isChecked) {
      onTapSelectedLevel(e);
    }
  }
}
