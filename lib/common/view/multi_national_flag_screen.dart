// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_flag_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/repository/util_repository.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/view/sign_up_university_screen.dart';

class MultiNationalFlagScreen extends ConsumerStatefulWidget {
  static String get routeName => 'multiNationalFlag';

  final SignUpModel signUpModel;
  const MultiNationalFlagScreen({
    super.key,
    required this.signUpModel,
  });

  @override
  ConsumerState<MultiNationalFlagScreen> createState() =>
      _MultiNationalFlagScreenState();
}

class _MultiNationalFlagScreenState
    extends ConsumerState<MultiNationalFlagScreen> {
  List<NationalFlagModel> nationalList = [];
  List<NationalFlagModel> tempList = [];
  List<NationalFlagModel> selectedModelList = [];
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
      tempList = nationalList;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTapTile(NationalFlagModel model) {
    if (selectedModelList.where((element) => model.id == element.id).isEmpty &&
        selectedModelList.length >= 3) {
      // 4개째에 새로운 것을 선택시
      showDefaultModal(
        context: context,
        function: () {
          context.pop();
        },
        buttonText: '확인',
        title: '국적은 3개까지 선택할 수 있어요',
      );
      return;
    }
    setState(() {
      if (selectedModelList.where((element) => model == element).isNotEmpty) {
        // 이미 선택한 경우
        selectedModelList.removeWhere((element) => model == element);
      } else {
        // 새로운 것을 선택한 경우
        selectedModelList.add(model);
      }
    });
  }

  onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        tempList = nationalList;
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
                '국적을 모두 선택해주세요',
                style: getTsHeading24(context).copyWith(
                  color: kColorContentDefault,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '변경할 수 없으니 정확히 선택해주세요',
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
                          children: tempList
                              .map((e) => ListFlagWidget(
                                    model: e,
                                    isCheck: selectedModelList.isNotEmpty &&
                                            selectedModelList
                                                .where((element) =>
                                                    e.id == element.id)
                                                .isNotEmpty
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
              if (MediaQuery.of(context).viewInsets.bottom <= 100)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 34,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (selectedModelList.length >= 2) {
                        context.goNamed(
                          UniversityScreen.routeName,
                          extra: widget.signUpModel.copyWith(
                            nationality_ids:
                                selectedModelList.map((e) => e.id).toList(),
                          ),
                        );
                      }
                    },
                    child: FilledButtonWidget(
                      text: '다음',
                      isEnable: selectedModelList.length >= 2,
                      height: 56,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
