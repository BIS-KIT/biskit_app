import 'package:biskit_app/common/components/list_tile_check_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/search_bar_widget.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';

class UnivListWidget extends StatefulWidget {
  final UniversityModel? selectedUnivModel;
  const UnivListWidget({
    Key? key,
    this.selectedUnivModel,
  }) : super(key: key);

  @override
  State<UnivListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivListWidget> {
  List<UniversityModel> univerisyList = [];
  List<UniversityModel> tempList = [];
  UniversityModel? selectedModel;
  bool isLoading = false;
  final TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    searchBarController.addListener(() {
      onChanged(searchBarController.text);
    });
  }

  // onTapSelectUnivStudentStatus() {
  //   showDefaultModalBottomSheet(
  //     context: context,
  //     title: '소속상태 선택',
  //     titleLeftButton: true,
  //     titleRightButton: true,
  //     height: 388,
  //     contentWidget: UnivStudentStatusListWidget(selectedUniv: selectedUniv),
  //   );
  // }

  init() async {
    setState(() {
      isLoading = true;
    });

    // TODO 학교 데이터 가져오는 부분
    // final UtilRepository utilRepository = UtilRepository(
    //   dio: Dio(),
    //   baseUrl: 'http://$kServerIp:$kServerPort/$kServerVersion',
    // );
    // await Future.microtask(() => null);
    // List univList = await utilRepository.getUniversty(
    //   languageCode: context.locale.languageCode,
    //   search: '',
    // );
    // logger.d(univList);

    await getUnivList();
    setState(() {
      selectedModel = widget.selectedUnivModel;
    });

    setState(() {
      isLoading = false;
    });
  }

  getUnivList() async {
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
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  void onTapTile(UniversityModel model) {
    setState(() {
      selectedModel = model;
    });
    FocusScope.of(context).unfocus();
    // setState(() {
    //   univerisyList = univerisyList.map((n) {
    //     if (n.ename == model.ename) {
    //       selectedModel = model;
    //       return model.copyWith(isCheck: true);
    //     } else {
    //       return n.copyWith(isCheck: false);
    //     }
    //   }).toList();
    // });
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SearchBarWidget(
              controller: searchBarController,
              onChanged: (value) {},
              hintText: '학교 검색',
            ),
            Expanded(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: tempList.isEmpty
                              ? univerisyList
                                  .map((e) => ListTileCheckWidget(
                                        text: e.kname,
                                        isChkecked:
                                            e == selectedModel ? true : false,
                                        isLevelView: false,
                                        onTap: () {
                                          onTapTile(e);
                                        },
                                      ))
                                  .toList()
                              : tempList
                                  .map((e) => ListTileCheckWidget(
                                        text: e.kname,
                                        isChkecked:
                                            e == selectedModel ? true : false,
                                        isLevelView: false,
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
                  if (selectedModel != null) {
                    Navigator.pop(context, selectedModel);
                  }
                  // Navigator.pop(context);
                  // onTapSelectUnivStudentStatus();
                },
                child: FilledButtonWidget(
                  text: '다음',
                  isEnable: selectedModel != null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
