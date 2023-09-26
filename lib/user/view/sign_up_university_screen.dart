// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/components/univ_student_graduate_status.dart';
import 'package:biskit_app/common/components/univ_student_status_list_widget.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:flutter/material.dart';

import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/univ_list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';

import '../../common/model/university_student_status_model.dart';

class UniversityScreen extends StatefulWidget {
  static String get routeName => 'universityScreen';

  final SignUpModel signUpModel;
  const UniversityScreen({
    Key? key,
    required this.signUpModel,
  }) : super(key: key);

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  UniversityModel? selectedUnivModel;
  UniversityStudentStatusModel? selectedStudentStatusModel;
  UniversityGraduateStatusModel? selectedGraduateStatusModel;

  int startBottomSheetIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  getUniv() async {
    return await showBiskitBottomSheet(
      context: context,
      title: '학교 선택',
      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
      isDismissible: false,
      onRightTap: () {
        setState(() {
          selectedUnivModel = null;
        });
        Navigator.pop(context);
      },
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          48,
      contentWidget: UnivListWidget(
        selectedUnivModel: selectedUnivModel,
      ),
    );
  }

  getStudentStatus() async {
    return await showBiskitBottomSheet(
      context: context,
      title: '소속상태 선택',
      leftIcon: 'assets/icons/ic_arrow_back_ios_line_24.svg',
      isDismissible: false,
      onLeftTap: () async {
        startBottomSheetIndex = 0;
        Navigator.pop(context);
        await onTapStartSelectedUniv();
      },
      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
      onRightTap: () {
        startBottomSheetIndex = 0;
        Navigator.pop(context);
      },
      contentWidget: UnivStudentStatusListWidget(
        selectedUnivStudentStatusModel: selectedStudentStatusModel,
      ),
    );
  }

  getGraduateStatus() async {
    return await showBiskitBottomSheet(
      context: context,
      title: '학적상태 선택',
      leftIcon: 'assets/icons/ic_arrow_back_ios_line_24.svg',
      isDismissible: false,
      onLeftTap: () async {
        startBottomSheetIndex = 1;
        Navigator.pop(context);
        await onTapStartSelectedUniv();
      },
      rightIcon: 'assets/icons/ic_cancel_line_24.svg',
      onRightTap: () {
        startBottomSheetIndex = 0;
        Navigator.pop(context);
      },
      contentWidget: UnivGraduateStatusListWidget(
        selectedStudentStatusModel: selectedStudentStatusModel!,
      ),
    );
  }

  onTapStartSelectedUniv() async {
    logger.d('startBottomSheetIndex : $startBottomSheetIndex');
    switch (startBottomSheetIndex) {
      case 0:
        selectedUnivModel = await getUniv();
        if (selectedUnivModel != null) {
          startBottomSheetIndex = 1;
          // 받아온 학교로 소속 시트 생성
          selectedStudentStatusModel = await getStudentStatus();
          if (selectedStudentStatusModel != null) {
            startBottomSheetIndex = 2;
            // 학적상태 선택 시트 생성
            if (!mounted) return;
            selectedGraduateStatusModel = await getGraduateStatus();
            if (selectedGraduateStatusModel != null) {
              setState(() {
                startBottomSheetIndex = 3;
              });

              // 선택한 데이터 추가하기
            }
          }
        }
        break;
      case 1:
        if (selectedUnivModel != null) {
          // 받아온 학교로 소속 시트 생성
          selectedStudentStatusModel = await getStudentStatus();
          if (selectedStudentStatusModel != null) {
            startBottomSheetIndex = 2;
            // 학적상태 선택 시트 생성
            if (!mounted) return;
            selectedGraduateStatusModel = await getGraduateStatus();
            if (selectedGraduateStatusModel != null) {
              setState(() {
                startBottomSheetIndex = 3;
              });

              // 선택한 데이터 추가하기
            }
          }
        }
        break;
      case 2:
        if (selectedStudentStatusModel != null) {
          // 학적상태 선택 시트 생성
          if (!mounted) return;
          selectedGraduateStatusModel = await getGraduateStatus();
          if (selectedGraduateStatusModel != null) {
            setState(() {
              startBottomSheetIndex = 3;
            });

            // 선택한 데이터 추가하기
          }
        }
        break;
      default:
    }

    // selectedUnivModel = await getUniv().then((r) {
    //   startBottomSheetIndex = 1;
    // });
    // if (selectedUnivModel != null) {
    //   logger.d(selectedUnivModel.toString());
    //   // 받아온 학교로 소속 시트 생성
    //   selectedStudentStatusModel = await getStudentStatus();

    //   if (selectedStudentStatusModel != null) {
    //     logger.d(selectedStudentStatusModel.toString());
    //     // 학적상태 선택 시트 생성
    //     if (!mounted) return;
    //     selectedGraduateStatusModel = await getGraduateStatus();
    //   }
    // }
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
                    // 상단 타이틀 부분
                    _buildTitleArea(context),
                    const SizedBox(
                      height: 32,
                    ),

                    // 선택 버튼
                    startBottomSheetIndex == 3
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: kColorBgElevation1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '학교',
                                          style:
                                              getTsBody16Sb(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          selectedUnivModel!.kname,
                                          style:
                                              getTsBody16Rg(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: kColorBorderDefalut,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '소속',
                                          style:
                                              getTsBody16Sb(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          selectedStudentStatusModel!.kname,
                                          style:
                                              getTsBody16Rg(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: kColorBorderDefalut,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '학적상태',
                                          style:
                                              getTsBody16Sb(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          selectedGraduateStatusModel!.kname,
                                          style:
                                              getTsBody16Rg(context).copyWith(
                                            color: kColorContentWeak,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    startBottomSheetIndex = 0;
                                    selectedUnivModel = null;
                                    selectedStudentStatusModel = null;
                                    selectedGraduateStatusModel = null;
                                  });
                                  onTapStartSelectedUniv();
                                },
                                child: const OutlinedButtonWidget(
                                  isEnable: true,
                                  text: '다시 선택하기',
                                  height: 52,
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: onTapStartSelectedUniv,
                            child: const OutlinedButtonWidget(
                              isEnable: true,
                              text: '학교 선택',
                              height: 52,
                            ),
                          ),
                  ],
                ),
              ),

              // 하단 버튼
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 34,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: FilledButtonWidget(
                    text: '가입하기',
                    isEnable: startBottomSheetIndex == 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildTitleArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '학교를 선택해주세요',
          style: getTsHeading24(context).copyWith(
            color: kColorContentDefault,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          '같은 학교의 친구들을 만날 수 있어요',
          style: getTsBody16Rg(context).copyWith(
            color: kColorContentWeaker,
          ),
        ),
      ],
    );
  }
}
