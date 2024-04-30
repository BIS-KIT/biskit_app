// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:biskit_app/common/components/outlined_button_widget.dart';
import 'package:biskit_app/common/components/univ_list_widget.dart';
import 'package:biskit_app/common/components/univ_student_graduate_status.dart';
import 'package:biskit_app/common/components/univ_student_status_list_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/model/api_res_model.dart';
import 'package:biskit_app/common/model/university_graduate_status_model.dart';
import 'package:biskit_app/common/model/university_model.dart';
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:biskit_app/common/utils/widget_util.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';
import 'package:biskit_app/user/provider/user_me_provider.dart';
import 'package:biskit_app/user/repository/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/model/university_student_status_model.dart';

class UniversityScreen extends ConsumerStatefulWidget {
  static String get routeName => 'universityScreen';

  final SignUpModel signUpModel;
  const UniversityScreen({
    Key? key,
    required this.signUpModel,
  }) : super(key: key);

  @override
  ConsumerState<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends ConsumerState<UniversityScreen> {
  UniversityModel? selectedUnivModel;
  UniversityStudentStatusModel? selectedStudentStatusModel;
  UniversityGraduateStatusModel? selectedGraduateStatusModel;

  UniversitySet? universitySet;

  int startBottomSheetIndex = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  getUniv() async {
    return await showBiskitBottomSheet(
      context: context,
      title: 'selectUnivBottomSheet.title'.tr(),
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
        onTap: (model) {
          setState(() {
            selectedUnivModel = model;
          });
        },
      ),
    );
  }

  getStudentStatus() async {
    return await showBiskitBottomSheet(
      context: context,
      title: 'selectDegreeBottomSheet.title'.tr(),
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
        onTap: (model) {
          setState(() {
            selectedStudentStatusModel = model;
          });
        },
      ),
    );
  }

  getGraduateStatus() async {
    return await showBiskitBottomSheet(
      context: context,
      title: 'selectStateBottomSheet.title'.tr(),
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
        onTap: (model) {
          setState(() {
            selectedGraduateStatusModel = model;
          });
        },
        submit: () {
          if (selectedUnivModel != null &&
              selectedStudentStatusModel != null &&
              selectedGraduateStatusModel != null) {
            setState(() {
              universitySet = UniversitySet(
                universityModel: selectedUnivModel!,
                universityStudentStatusModel: selectedStudentStatusModel!,
                universityGraduateStatusModel: selectedGraduateStatusModel!,
              );
            });
          }
        },
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
  }

  onTapSignUp() async {
    if (universitySet != null) {
      ApiResModel apiResModel;
      context.loaderOverlay.show();

      // Sign up
      apiResModel = await ref.read(authRepositoryProvider).signUpEmail(
            widget.signUpModel.copyWith(
              university_id: universitySet!.universityModel.id,
              department: context.locale.languageCode == 'en'
                  ? universitySet!.universityStudentStatusModel.ename
                  : universitySet!.universityStudentStatusModel.kname,
              education_status: context.locale.languageCode == 'en'
                  ? universitySet!.universityGraduateStatusModel.ename
                  : universitySet!.universityGraduateStatusModel.kname,
            ),
          );
      if (!mounted) return;
      context.loaderOverlay.hide();
      if (apiResModel.isOk) {
        // 성공시
        if (apiResModel.data != null) {
          ref.read(userMeProvider.notifier).signUpGetMe(
                accessToken: apiResModel.data!['token'],
                refreshToken: apiResModel.data!['refresh_token'],
              );
        }
      } else {
        showSnackBar(
          context: context,
          text: apiResModel.message ?? '',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
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
                  universitySet != null
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'signUpSelectUnivCompleteScreen.univ'
                                            .tr(),
                                        style: getTsBody16Sb(context).copyWith(
                                          color: kColorContentWeak,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        context.locale.languageCode == 'en'
                                            ? universitySet!
                                                .universityModel.en_name
                                            : universitySet!
                                                .universityModel.kr_name,
                                        style: getTsBody16Rg(context).copyWith(
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
                                    height: 1,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'signUpSelectUnivCompleteScreen.degree'
                                            .tr(),
                                        style: getTsBody16Sb(context).copyWith(
                                          color: kColorContentWeak,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        context.locale.languageCode == 'en'
                                            ? universitySet!
                                                .universityStudentStatusModel
                                                .ename
                                            : universitySet!
                                                .universityStudentStatusModel
                                                .kname,
                                        style: getTsBody16Rg(context).copyWith(
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
                                    height: 1,
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
                                        'signUpSelectUnivCompleteScreen.state'
                                            .tr(),
                                        style: getTsBody16Sb(context).copyWith(
                                          color: kColorContentWeak,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        context.locale.languageCode == 'en'
                                            ? universitySet!
                                                .universityGraduateStatusModel
                                                .ename
                                            : universitySet!
                                                .universityGraduateStatusModel
                                                .kname,
                                        style: getTsBody16Rg(context).copyWith(
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

                                  // 다시 선택하기 눌렀을때 값 유지
                                  // selectedUnivModel = null;
                                  // selectedStudentStatusModel = null;
                                  // selectedGraduateStatusModel = null;
                                });
                                onTapStartSelectedUniv();
                              },
                              child: OutlinedButtonWidget(
                                isEnable: true,
                                text:
                                    'signUpSelectUnivCompleteScreen.edit'.tr(),
                                height: 52,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: onTapStartSelectedUniv,
                          child: OutlinedButtonWidget(
                            isEnable: true,
                            text: 'selectUnivBottomSheet.title'.tr(),
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
                onTap: onTapSignUp,
                child: FilledButtonWidget(
                  text: 'signUpSelectUnivCompleteScreen.create'.tr(),
                  isEnable: universitySet != null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTitleArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'signUpSelectUnivScreen.title'.tr(),
          style: getTsHeading24(context).copyWith(
            color: kColorContentDefault,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'signUpSelectUnivScreen.subtitle'.tr(),
          style: getTsBody16Rg(context).copyWith(
            color: kColorContentWeaker,
          ),
        ),
      ],
    );
  }
}

class UniversitySet {
  UniversityModel universityModel;
  UniversityStudentStatusModel universityStudentStatusModel;
  UniversityGraduateStatusModel universityGraduateStatusModel;
  UniversitySet({
    required this.universityModel,
    required this.universityStudentStatusModel,
    required this.universityGraduateStatusModel,
  });
}
