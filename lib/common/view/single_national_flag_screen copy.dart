import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_tile_img_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/view/multi_national_flag_screen.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repository/util_repository.dart';

class SingleNationalFlagScreen extends ConsumerStatefulWidget {
  static String get routeName => 'singleNationalFlag';
  const SingleNationalFlagScreen({super.key});

  @override
  ConsumerState<SingleNationalFlagScreen> createState() =>
      _SingleNationalFlagScreenState();
}

class _SingleNationalFlagScreenState
    extends ConsumerState<SingleNationalFlagScreen> {
  List<NationalFlagModel> nationalList = [];
  List<NationalFlagModel> tempList = [];
  NationalFlagModel? selectedModel;
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
    textEditingController.addListener(() {
      onChanged(textEditingController.text);
    });
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
    setState(() {
      isLoading = false;
      nationalList = list;
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
      // nationalList = nationalList.map((n) {
      //   if (n == model) {
      //     return model.copyWith(isCheck: true);
      //   } else {
      //     return n.copyWith(isCheck: false);
      //   }
      // }).toList();
    });
  }

  onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        tempList = [];
      });
    } else {
      List<NationalFlagModel> searchList = nationalList
          .where((n) => '${n.en_name.toLowerCase()} ${n.kr_name.toLowerCase()}'
              .contains(value.toLowerCase()))
          .toList();
      setState(() {
        tempList = searchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
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
                '국적을 선택해주세요',
                style: getTsHeading24(context).copyWith(
                  color: kColorGray9,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '변경할 수 없으니 정확히 선택해주세요',
                style: getTsBody16Rg(context).copyWith(
                  color: kColorGray7,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SearchBarWidget(
                controller: textEditingController,
                onChanged: (value) {},
                hintText: '국적 검색',
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CustomLoading(),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: tempList.isEmpty
                              ? nationalList
                                  .map((e) => ListTileImgWidget(
                                        model: e,
                                        isCheck: selectedModel != null &&
                                                selectedModel!.id == e.id
                                            ? true
                                            : false,
                                        onTap: () {
                                          onTapTile(e);
                                        },
                                      ))
                                  .toList()
                              : tempList
                                  .map((e) => ListTileImgWidget(
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // check
                          selectedModel = null;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MultiNationalFlagScreen(),
                            ));
                      },
                      child: Text(
                        '복수국적인가요?',
                        style: getTsBody14Rg(context).copyWith(
                          color: kColorGray6,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedModel != null) {
                          context.goNamed(UniversityScreen.routeName);
                        }
                      },
                      child: FilledButtonWidget(
                        text: '다음',
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
      ),
    );
  }
}
