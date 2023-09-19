import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_level_widget.dart';
import 'package:biskit_app/common/component/list_tile_univ_department_widget.dart';
import 'package:biskit_app/common/component/list_tile_widget.dart';
import 'package:biskit_app/common/component/outlined_button_widget.dart';
import 'package:biskit_app/common/component/search_bar_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UniversityScreen extends StatefulWidget {
  static String get routeName => 'universityScreen';
  const UniversityScreen({super.key});

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  List<UniversityModel> univerisyList = [];
  List<UniversityModel> tempList = [];
  UniversityModel? selectedModel;
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
      jsonPath: 'assets/jsons/university.json',
    );

    if (!mounted) return;
    if (context.locale.languageCode == kEn) {
      // 영문
      setState(() {
        univerisyList = data
            .map((d) => UniversityModel(
                code: d['code'], ename: d['ename'], kname: d['kname']))
            .toList();
        univerisyList.sort((a, b) {
          return a.ename.toLowerCase().compareTo(b.ename.toLowerCase());
        });
      });
    } else {
      // 국문
      setState(() {
        univerisyList = data
            .map((d) => UniversityModel(
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

  void onTapTile(UniversityModel model) {
    setState(() {
      univerisyList = univerisyList.map((n) {
        if (n == model) {
          selectedModel = model;
          return model.copyWith(isCheck: true);
        } else {
          return n.copyWith(isCheck: false);
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
      List<UniversityModel> searchList = univerisyList
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '학교를 선택해주세요',
                  style: getTsHeading24(context).copyWith(
                    color: kColorGray9,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '같은 학교의 친구들을 만날 수 있어요',
                  style: getTsBody16Rg(context).copyWith(
                    color: kColorGray7,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () {
                    showDefaultModalBottomSheet(
                      context: context,
                      title: '학교 선택',
                      titleLeftButton: true,
                      titleRightButton: true,
                      contentWidget: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SearchBarWidget(
                              controller: textEditingController,
                              onChanged: onChanged,
                              hintText: '학교 검색',
                            ),
                            Expanded(
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        child: Column(
                                          children: tempList.isEmpty
                                              ? univerisyList
                                                  .map((e) => ListTileWidget(
                                                        model: e,
                                                        onTap: () {
                                                          onTapTile(e);
                                                        },
                                                      ))
                                                  .toList()
                                              : tempList
                                                  .map((e) => ListTileWidget(
                                                        model: e,
                                                        onTap: () {
                                                          onTapTile(e);
                                                        },
                                                      ))
                                                  .toList(),
                                        ),
                                      )),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 34,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDefaultModalBottomSheet(
                                    context: context,
                                    title: '소속 선택',
                                    titleLeftButton: true,
                                    titleRightButton: true, height: 388,
                                    // MediaQuery.of(context)
                                    //         .size
                                    //         .height -
                                    //     MediaQuery.of(context).padding.top -
                                    //     424,
                                    contentWidget: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          const Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  ListTileUnivDepartmentWidget(
                                                    isCheck: true,
                                                    department: '학부',
                                                  ),
                                                  ListTileUnivDepartmentWidget(
                                                    isCheck: false,
                                                    department: '대학원',
                                                  ),
                                                  ListTileUnivDepartmentWidget(
                                                    isCheck: false,
                                                    department: '교환학생',
                                                  ),
                                                  ListTileUnivDepartmentWidget(
                                                    isCheck: false,
                                                    department: '어학당',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDefaultModalBottomSheet(
                                                context: context,
                                                title: '학적상태 선택',
                                                titleLeftButton: true,
                                                titleRightButton: true,
                                                height: 332,
                                                contentWidget: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(
                                                    children: [
                                                      const Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              ListTileUnivDepartmentWidget(
                                                                isCheck: true,
                                                                department:
                                                                    '재학',
                                                              ),
                                                              ListTileUnivDepartmentWidget(
                                                                isCheck: false,
                                                                department:
                                                                    '수료',
                                                              ),
                                                              ListTileUnivDepartmentWidget(
                                                                isCheck: false,
                                                                department:
                                                                    '졸업',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 16,
                                                            bottom: 34,
                                                          ),
                                                          child:
                                                              FilledButtonWidget(
                                                            text: '완료',
                                                            isEnable: false,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                top: 16,
                                                bottom: 34,
                                              ),
                                              child: FilledButtonWidget(
                                                text: '다음',
                                                isEnable: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: const FilledButtonWidget(
                                    text: '다음', isEnable: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const OutlinedButtonWidget(
                    isEnable: true,
                    text: '학교 선택',
                    height: 52,
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 34,
              ),
              child: GestureDetector(
                onTap: () {},
                child: const FilledButtonWidget(text: '다음', isEnable: true),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
