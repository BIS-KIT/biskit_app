import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_univ_student_status_widget.dart';
import 'package:biskit_app/common/component/univ_student_graduate_status.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnivStudentStatusListWidget extends StatefulWidget {
  const UnivStudentStatusListWidget({
    super.key,
  });

  @override
  State<UnivStudentStatusListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivStudentStatusListWidget> {
  List<UniversityStudentStatusModel> univerisyStudentStatusList = [];
  List<UniversityStudentStatusModel> tempList = [];
  UniversityStudentStatusModel? selectedModel;
  bool isLoading = false;
  bool isUnivStudentStatusSelected = false;
  String selectedStudentStatus = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  onTapSelectUnivGraduateStatus() {
    showDefaultModalBottomSheet(
      context: context,
      title: '학적상태 선택',
      titleLeftButton: true,
      titleRightButton: true,
      height: 388,
      contentWidget:
          UnivGraduateStatusListWidget(selected: selectedStudentStatus),
    );
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    final List data = await readJson(
      jsonPath: 'assets/jsons/university-student-status.json',
    );

    if (!mounted) return;
    if (context.locale.languageCode == kEn) {
      // 영문
      setState(() {
        univerisyStudentStatusList = data
            .map((d) => UniversityStudentStatusModel(
                ename: d['ename'], kname: d['kname']))
            .toList();
        univerisyStudentStatusList.sort((a, b) {
          return a.ename.toLowerCase().compareTo(b.ename.toLowerCase());
        });
      });
    } else {
      // 국문
      setState(() {
        univerisyStudentStatusList = data
            .map((d) => UniversityStudentStatusModel(
                ename: d['ename'], kname: d['kname']))
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
  }

  void onTapTile(UniversityStudentStatusModel model) {
    setState(() {
      univerisyStudentStatusList = univerisyStudentStatusList.map((n) {
        if (n.ename == model.ename) {
          selectedModel = model;
          return model.copyWith(isCheck: true);
        } else {
          return n.copyWith(isCheck: false);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: tempList.isEmpty
                            ? univerisyStudentStatusList
                                .map((e) => ListTileUnivStudentStatusWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isUnivStudentStatusSelected = true;
                                          selectedStudentStatus = e.kname;
                                        });
                                      },
                                    ))
                                .toList()
                            : tempList
                                .map((e) => ListTileUnivStudentStatusWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isUnivStudentStatusSelected = true;
                                          selectedStudentStatus = e.kname;
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
                onTapSelectUnivGraduateStatus();
              },
              child: FilledButtonWidget(
                text: '다음',
                isEnable: isUnivStudentStatusSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
