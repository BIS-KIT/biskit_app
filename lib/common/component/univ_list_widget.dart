import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_univ_widget.dart';
import 'package:biskit_app/common/component/search_bar_widget.dart';
import 'package:biskit_app/common/component/univ_student_status_list_widget.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnivListWidget extends StatefulWidget {
  const UnivListWidget({
    super.key,
  });

  @override
  State<UnivListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivListWidget> {
  List<UniversityModel> univerisyList = [];
  List<UniversityModel> tempList = [];
  UniversityModel? selectedModel;
  bool isLoading = false;
  bool isUnivSelected = false;
  final TextEditingController searchBarController = TextEditingController();
  String selectedUniv = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  onTapSelectUnivStudentStatus() {
    showDefaultModalBottomSheet(
      context: context,
      title: '소속상태 선택',
      titleLeftButton: true,
      titleRightButton: true,
      height: 388,
      contentWidget: UnivStudentStatusListWidget(selectedUniv: selectedUniv),
    );
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
    super.dispose();
    searchBarController.dispose();
  }

  void onTapTile(UniversityModel model) {
    setState(() {
      univerisyList = univerisyList.map((n) {
        if (n.ename == model.ename) {
          selectedModel = model;
          return model.copyWith(isCheck: true);
        } else {
          return n.copyWith(isCheck: false);
        }
      }).toList();
    });
  }

  onChanged(String value) {
    logger.d(univerisyList);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SearchBarWidget(
            controller: searchBarController,
            onChanged: onChanged,
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
                                .map((e) => ListTileWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isUnivSelected = true;
                                          selectedUniv = e.kname;
                                        });
                                      },
                                    ))
                                .toList()
                            : tempList
                                .map((e) => ListTileWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isUnivSelected = true;
                                          selectedUniv = e.kname;
                                        });
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
                // Navigator.pop(context);
                onTapSelectUnivStudentStatus();
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable: isUnivSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
