import 'package:biskit_app/common/components/check_circle.dart';
import 'package:biskit_app/common/components/custom_loading.dart';
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_student_status_model.dart';
import 'package:flutter/material.dart';

class UnivGraduateStatusListWidget extends StatefulWidget {
  final UniversityStudentStatusModel selectedStudentStatusModel;
  const UnivGraduateStatusListWidget({
    super.key,
    required this.selectedStudentStatusModel,
  });

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
            ename: '재학',
            kname: '재학',
          ),
          UniversityGraduateStatusModel(
            ename: '수료',
            kname: '수료',
          ),
          UniversityGraduateStatusModel(
            ename: '졸업',
            kname: '졸업',
          ),
        ];
      } else {
        univerisyGraduateStatusList = [
          UniversityGraduateStatusModel(
            ename: '재학',
            kname: '재학',
          ),
          UniversityGraduateStatusModel(
            ename: '수료',
            kname: '수료',
          ),
        ];
      }
    });

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
          isLoading
              ? const Center(
                  child: CustomLoading(),
                )
              : Column(
                  children: univerisyGraduateStatusList
                      .map(
                        (e) => ListWidget(
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
                          },
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
                  Navigator.pop(
                    context,
                    selectedModel,
                  );
                }
              },
              child: FilledButtonWidget(
                text: '완료',
                isEnable: selectedModel != null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
