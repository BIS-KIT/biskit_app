import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_flag_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../repository/util_repository.dart';

class SingleNationalFlagScreen extends ConsumerStatefulWidget {
  static String get routeName => 'singleNationalFlag';

  final SignUpModel signUpModel;
  const SingleNationalFlagScreen({
    super.key,
    required this.signUpModel,
  });

  @override
  ConsumerState<SingleNationalFlagScreen> createState() =>
      _SingleNationalFlagScreenState();
}

class _SingleNationalFlagScreenState
    extends ConsumerState<SingleNationalFlagScreen> {
  final AutoScrollController autoScrollController = AutoScrollController();
  int startScrollIndex = 0;
  int nextStartIndex = 0;
  final int pageMaxCount = 20;

  List<NationalFlagModel> nationalList = [];
  List<NationalFlagModel> tempList = [];
  NationalFlagModel? selectedModel;
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    autoScrollController.scrollToIndex(
      startScrollIndex,
      preferPosition: AutoScrollPosition.begin,
    );
    autoScrollController.addListener(() {
      if (autoScrollController.offset >
          autoScrollController.position.maxScrollExtent - 300) {
        if (nextStartIndex >= nationalList.length ||
            textEditingController.text.isNotEmpty) {
          return;
        }

        if (nextStartIndex + pageMaxCount > nationalList.length) {
          setState(() {
            tempList.addAll(
                nationalList.getRange(nextStartIndex, nationalList.length));
          });
        } else {
          setState(() {
            tempList.addAll(nationalList.getRange(
                nextStartIndex, nextStartIndex + pageMaxCount));
          });
        }
        nextStartIndex = tempList.length;
      }
    });
    textEditingController.addListener(() {
      // logger.d('textEditingController : ${textEditingController.text}');
      autoScrollController.jumpTo(0);
      onChanged(textEditingController.text);
    });
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    await Future.microtask(() => null);
    if (!mounted) return;
    List<NationalFlagModel> list =
        await ref.read(utilRepositoryProvider).getNationality(
              osLanguage: context.locale.languageCode,
              search: '',
            );
    nationalList = list;
    setState(() {
      setFirstData();
      isLoading = false;
    });
  }

  setFirstData() {
    setState(() {
      tempList = nationalList.getRange(0, pageMaxCount).toList();
      nextStartIndex = tempList.length;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTapTile(NationalFlagModel model) {
    setState(() {
      // check
      selectedModel = model;
    });
    FocusScope.of(context).unfocus();
  }

  onChanged(String value) {
    if (value.isEmpty) {
      setFirstData();
    } else {
      // TODO 영문의 경우도 처리해야함
      List<NationalFlagModel> searchList = nationalList
          .where((n) => n.kr_name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      searchList.sort((a, b) {
        int indexOfA = a.kr_name.toLowerCase().indexOf(value.toLowerCase());
        int indexOfB = b.kr_name.toLowerCase().indexOf(value.toLowerCase());
        if (indexOfA >= 0 && indexOfB >= 0) {
          return indexOfA - indexOfB;
        } else if (indexOfA >= 0) {
          return -1;
        } else if (indexOfB >= 0) {
          return 1;
        } else {
          return 0;
        }
      });
      setState(() {
        tempList = searchList;
      });
    }
    // logger.d('tempList.length : ${tempList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              'signUpNationalityScreen.title'.tr(),
              style: getTsHeading24(context).copyWith(
                color: kColorContentDefault,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'signUpNationalityScreen.subtitle'.tr(),
              style: getTsBody16Rg(context).copyWith(
                color: kColorContentWeaker,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SearchBarWidget(
              controller: textEditingController,
              onChanged: (value) {},
              hintText: 'signUpNationalityScreen.searchBar'.tr(),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CustomLoading(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: SingleChildScrollView(
                        controller: autoScrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: tempList
                              .map((e) => ListFlagWidget(
                                    model: e,
                                    isCheck: selectedModel != null &&
                                            selectedModel!.id == e.id
                                        ? true
                                        : false,
                                    onTap: () {
                                      onTapTile(e);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom <= 100)
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // XXX: 이중국적은 우선 빼기로 결정
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       // check
                    //       selectedModel = null;
                    //     });
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => MultiNationalFlagScreen(
                    //             signUpModel: widget.signUpModel,
                    //           ),
                    //         ));
                    //   },
                    //   child: Text(
                    //     'signUpNationalityScreen.multinational'.tr(),
                    //     style: getTsBody14Rg(context).copyWith(
                    //       color: kColorContentWeakest,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedModel != null) {
                          context.goNamed(
                            UniversityScreen.routeName,
                            extra: widget.signUpModel.copyWith(
                              nationality_ids: [selectedModel!.id],
                            ),
                          );
                        }
                      },
                      child: FilledButtonWidget(
                        text: 'signUpNationalityScreen.next'.tr(),
                        isEnable: selectedModel != null,
                        height: 56,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
