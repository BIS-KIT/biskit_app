import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_tile_img_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/national_flag_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MultiNationalFlagScreen extends StatefulWidget {
  static String get routeName => 'multiNationalFlag';
  const MultiNationalFlagScreen({super.key});

  @override
  State<MultiNationalFlagScreen> createState() =>
      _MultiNationalFlagScreenState();
}

class _MultiNationalFlagScreenState extends State<MultiNationalFlagScreen> {
  List<NationalFlagModel> nationalList = [];
  List<NationalFlagModel> tempList = [];
  List<NationalFlagModel> selectedModelList = [];
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    final List data = await readJson(
      jsonPath: 'assets/jsons/national-flag.json',
    );
    // logger.d(data);
    if (!mounted) return;
    if (context.locale.languageCode == kEn) {
      // 영문
      setState(() {
        nationalList = data
            .map((d) => NationalFlagModel(
                code: d['code'], ename: d['ename'], kname: d['kname']))
            .toList();
        nationalList.sort((a, b) {
          return a.ename.toLowerCase().compareTo(b.ename.toLowerCase());
        });
      });
    } else {
      // 국문
      setState(() {
        nationalList = data
            .map((d) => NationalFlagModel(
                code: d['code'], ename: d['ename'], kname: d['kname']))
            .toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTapTile(NationalFlagModel model) {
    if (!model.isCheck && selectedModelList.length >= 3) {
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
      // check
      nationalList = nationalList.map((n) {
        if (n == model) {
          NationalFlagModel m = model.copyWith(isCheck: !model.isCheck);
          if (m.isCheck) {
            selectedModelList.add(m);
          } else {
            selectedModelList =
                selectedModelList.where((element) => element != model).toList();
          }
          return m;
        } else {
          return n;
        }
      }).toList();
    });
  }

  onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        tempList = [];
      });
    } else {
      List<NationalFlagModel> searchList = nationalList
          .where((n) => '${n.ename.toLowerCase()} ${n.kname.toLowerCase()}'
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
                onChanged: onChanged,
                hintText: '국적 검색',
              ),
              Expanded(
                child: isLoading
                    ? const CircularProgressIndicator()
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
                                        onTap: () {
                                          onTapTile(e);
                                        },
                                      ))
                                  .toList()
                              : tempList
                                  .map((e) => ListTileImgWidget(
                                        model: e,
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
                child: FilledButtonWidget(
                  text: '다음',
                  isEnable: selectedModelList.length >= 2,
                  height: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
