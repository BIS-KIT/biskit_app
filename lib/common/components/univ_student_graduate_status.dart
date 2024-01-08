// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_widget_temp.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';

class UnivGraduateStatusListWidget extends StatefulWidget {
  final UniversityStudentStatusModel selectedStudentStatusModel;
  final UniversityGraduateStatusModel? selectedGraduateStatusModel;
  final Function(UniversityGraduateStatusModel) onTap;
  final Function() submit;
  const UnivGraduateStatusListWidget({
    Key? key,
    required this.selectedStudentStatusModel,
    this.selectedGraduateStatusModel,
    required this.onTap,
    required this.submit,
  }) : super(key: key);

  @override
  State<UnivGraduateStatusListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivGraduateStatusListWidget> {
  List<UniversityGraduateStatusModel> univerisyGraduateStatusList = [];
  UniversityGraduateStatusModel? selectedModel;
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
    setState(() {
      if (widget.selectedStudentStatusModel.kname == "학부" ||
          widget.selectedStudentStatusModel.kname == "대학원") {
        univerisyGraduateStatusList = [
          UniversityGraduateStatusModel(
            ename: 'Attending',
            kname: '재학',
          ),
          UniversityGraduateStatusModel(
            ename: 'Completed',
            kname: '수료',
          ),
          UniversityGraduateStatusModel(
            ename: 'Graduated',
            kname: '졸업',
          ),
        ];
      } else {
        univerisyGraduateStatusList = [
          UniversityGraduateStatusModel(
            ename: 'Attending',
            kname: '재학',
          ),
          UniversityGraduateStatusModel(
            ename: 'Completed',
            kname: '수료',
          ),
        ];
      }
    });

    setState(() {
      if (widget.selectedGraduateStatusModel != null) {
        selectedModel = widget.selectedGraduateStatusModel;
      }
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          isLoading
              ? const Center(
                  child: CustomLoading(),
                )
              : Column(
                  children: univerisyGraduateStatusList
                      .map(
                        (e) => ListWidgetTemp(
                          height: 56,
                          borderColor: e == univerisyGraduateStatusList.last
                              ? kColorBgDefault
                              : kColorBorderDefalut,
                          touchWidget: CheckCircleWidget(
                            value: selectedModel == e,
                          ),
                          onTap: () {
                            setState(() {
                              selectedModel = e;
                            });
                            widget.onTap(e);
                          },
                          // TODO: 언어에 따라 다르게 보여줘야함
                          centerWidget: Text(
                            e.kname,
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorContentWeak,
                            ),
                          ),
                        ),
                      )
                      .toList()),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 34,
            ),
            child: GestureDetector(
              onTap: () {
                if (selectedModel != null) {
                  widget.submit();
                  Navigator.pop(
                    context,
                    selectedModel,
                  );
                }
              },
              child: FilledButtonWidget(
                text: 'selectStateBottomSheet2.done'.tr(),
                isEnable: selectedModel != null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
