import 'package:biskit_app/common/component/filled_button_widget.dart';
import 'package:biskit_app/common/component/list_tile_univ_graduate_status_widget.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/utils/json_util.dart';
import 'package:biskit_app/user/view/sign_up_university_completed_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnivGraduateStatusListWidget extends StatefulWidget {
  final String? selectedStudentStatus;
  final String? selectedUniv;
  const UnivGraduateStatusListWidget({
    super.key,
    this.selectedStudentStatus,
    this.selectedUniv,
  });

  @override
  State<UnivGraduateStatusListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivGraduateStatusListWidget> {
  List<UniversityGraduateStatusModel> univerisyGraduateStatusList = [];
  List<UniversityGraduateStatusModel> tempList = [];
  UniversityGraduateStatusModel? selectedModel;
  bool isLoading = false;
  bool isStudentGraduateSelected = false;
  String selectedGraduateStatus = '';
  List? data;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    if (widget.selectedStudentStatus == "학부" ||
        widget.selectedStudentStatus == "대학원") {
      data = await readJson(
        jsonPath: 'assets/jsons/university-graduate-status.json',
      );
    } else {
      data = await readJson(
        jsonPath: 'assets/jsons/university-graduate-foreign-status.json',
      );
    }

    if (!mounted) return;
    if (context.locale.languageCode == kEn) {
      // 영문
      setState(() {
        univerisyGraduateStatusList = data!
            .map((d) => UniversityGraduateStatusModel(
                ename: d['ename'], kname: d['kname']))
            .toList();
        univerisyGraduateStatusList.sort((a, b) {
          return a.ename.toLowerCase().compareTo(b.ename.toLowerCase());
        });
      });
    } else {
      // 국문
      setState(() {
        univerisyGraduateStatusList = data!
            .map((d) => UniversityGraduateStatusModel(
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

  void onTapTile(UniversityGraduateStatusModel model) {
    setState(() {
      univerisyGraduateStatusList = univerisyGraduateStatusList.map((n) {
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
                            ? univerisyGraduateStatusList
                                .map((e) => ListTileUnivGraduateStatusWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isStudentGraduateSelected = true;
                                          selectedGraduateStatus = e.kname;
                                        });
                                      },
                                    ))
                                .toList()
                            : tempList
                                .map((e) => ListTileUnivGraduateStatusWidget(
                                      model: e,
                                      onTap: () {
                                        onTapTile(e);
                                        setState(() {
                                          isStudentGraduateSelected = true;
                                          selectedGraduateStatus = e.kname;
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UniversityCompletedScreen(
                          selectedUniv: widget.selectedUniv,
                          selectedStudentStatus: widget.selectedStudentStatus,
                          selectedGraduateStatus: selectedGraduateStatus)),
                );
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable: isStudentGraduateSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
