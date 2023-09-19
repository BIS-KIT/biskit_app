import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_check_widget.dart';
import 'package:biskit_app/common/component/list_tile_level_widget.dart';
import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/component/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:flutter/material.dart';

class SignUpLanguageScreen extends StatefulWidget {
  const SignUpLanguageScreen({super.key});

  @override
  State<SignUpLanguageScreen> createState() => _SignUpLanguageScreenState();
}

class _SignUpLanguageScreenState extends State<SignUpLanguageScreen> {
  late TextEditingController searchBarController;

  @override
  void initState() {
    super.initState();

    searchBarController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  // 언어선택
  onTapSelectedLang() {
    showDefaultModalBottomSheet(
      context: context,
      title: '언어 선택',
      titleRightButton: true,
      contentWidget: Padding(
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
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: true,
                      isLevelView: true,
                      level: 3,
                      onTapLevel: () {
                        FocusScope.of(context).unfocus();
                        showDefaultModalBottomSheet(
                          context: context,
                          title: '레벨 선택',
                          titleRightButton: true,
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              200,
                          contentWidget: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListTileLevelWidget(
                                          isChkecked: false,
                                          level: 5,
                                        ),
                                        ListTileLevelWidget(
                                          isChkecked: false,
                                          level: 4,
                                        ),
                                        ListTileLevelWidget(
                                          isChkecked: true,
                                          level: 3,
                                        ),
                                        ListTileLevelWidget(
                                          isChkecked: false,
                                          level: 2,
                                        ),
                                        ListTileLevelWidget(
                                          isChkecked: false,
                                          level: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16,
                                    bottom: 34,
                                  ),
                                  child: FilledButtonWidget(
                                    text: '완료',
                                    isEnable: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                    const ListTileCheckWidget(
                      text: '한국어',
                      isChkecked: false,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: FilledButtonWidget(
                text: '완료',
                isEnable: false,
              ),
            ),
          ],
        ),
      ),
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
              child: const FilledButtonWidget(
                text: '다음',
                isEnable: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
