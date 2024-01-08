// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_widget_temp.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';

class UnivStudentStatusListWidget extends StatefulWidget {
  final UniversityStudentStatusModel? selectedUnivStudentStatusModel;
  final Function(UniversityStudentStatusModel) onTap;
  const UnivStudentStatusListWidget({
    Key? key,
    this.selectedUnivStudentStatusModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UnivStudentStatusListWidget> createState() => _UnivListWidgetState();
}

class _UnivListWidgetState extends State<UnivStudentStatusListWidget> {
  List<UniversityStudentStatusModel> univerisyStudentStatusList = [];
  UniversityStudentStatusModel? selectedModel;
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
      univerisyStudentStatusList = [
        // TODO 영어명
        UniversityStudentStatusModel(
          ename: 'Undergraduate',
          kname: '학부',
        ),
        UniversityStudentStatusModel(
          ename: 'Graduate',
          kname: '대학원',
        ),
        UniversityStudentStatusModel(
          ename: 'Exchange Student',
          kname: '교환학생',
        ),
        UniversityStudentStatusModel(
          ename: 'Language Course',
          kname: '어학당',
        ),
      ];
    });
    setState(() {
      selectedModel = widget.selectedUnivStudentStatusModel;
    });

    setState(() {
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
                  children: univerisyStudentStatusList
                      .map(
                        (e) => ListWidgetTemp(
                          height: 56,
                          borderColor: e == univerisyStudentStatusList.last
                              ? kColorBgDefault
                              : kColorBorderDefalut,
                          touchWidget: CheckCircleWidget(
                            value: e == selectedModel,
                          ),
                          onTap: () {
                            setState(() {
                              selectedModel = e;
                            });
                            widget.onTap(e);
                          },
                          centerWidget: Text(
                            e.kname,
                            style: getTsBody16Rg(context).copyWith(
                              color: kColorContentWeak,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
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
              },
              child: FilledButtonWidget(
                text: 'selectDegreeBottomSheet.next'.tr(),
                isEnable: selectedModel != null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
