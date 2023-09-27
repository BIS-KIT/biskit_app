// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biskit_app/common/utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:biskit_app/common/components/custom_text_form_field.dart';
import 'package:biskit_app/common/components/full_bleed_button_widget.dart';
import 'package:biskit_app/common/components/radio_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/single_national_flag_screen%20copy.dart';
import 'package:biskit_app/user/model/sign_up_model.dart';

class NameBirthGenderScreen extends StatefulWidget {
  static String get routeName => 'nameBirthGender';

  final SignUpModel signUpModel;
  const NameBirthGenderScreen({
    Key? key,
    required this.signUpModel,
  }) : super(key: key);

  @override
  State<NameBirthGenderScreen> createState() => _NameBirthGenderScreenState();
}

class _NameBirthGenderScreenState extends State<NameBirthGenderScreen> {
  String name = '';
  String birthYear = '';
  String birthMonth = '';
  String birthDay = '';
  String? nameError;
  String? birthYearError;
  String? birthMonthError;
  String? birthDayError;
  bool isValidName = false;
  bool isValidBirth = false;
  bool isValidGender = false;
  late FocusNode birthMonthFocusNode;
  late FocusNode birthDayFocusNode;
  late FocusNode nameFocusNode;
  RadioWidgetValueType selectGender = RadioWidgetValueType.none;

  @override
  void initState() {
    super.initState();
    logger.d(widget.signUpModel.toString());
    nameFocusNode = FocusNode();
    birthMonthFocusNode = FocusNode();
    birthDayFocusNode = FocusNode();
    nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    birthMonthFocusNode.dispose();
    birthDayFocusNode.dispose();
  }

  bool isValidNameType(String name) {
    RegExp koreanEnglishRegExp = RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+$');
    return koreanEnglishRegExp.hasMatch(name);
  }

  checkIsValidForm() {
    return isValidName && isValidGender;
  }

  checkIsValidBirth() {
    if (birthYear.isNotEmpty &&
        birthYearError == null &&
        birthMonth.isNotEmpty &&
        birthMonthError == null &&
        birthDay.isNotEmpty &&
        birthDayError == null) {
      setState(() {
        isValidBirth = true;
      });
    }
  }

  checkName() {
    if (name == '') {
      setState(() {
        nameError = null;
      });
    } else if (!isValidNameType(name)) {
      setState(() {
        nameError = '한글 또는 영문으로 입력해주세요';
      });
    } else {
      setState(() {
        nameError = null;
        isValidName = true;
      });
    }
  }

  checkYear() {
    if (birthYear.length > 1 && int.parse(birthYear.substring(0, 2)) < 19) {
      setState(() {
        birthYearError = '';
      });
    } else if (birthYear.length == 4) {
      birthYearError = null;
      FocusScope.of(context).requestFocus(birthMonthFocusNode);
    } else {
      setState(() {
        birthYearError = null;
      });
    }
  }

  checkMonth() {
    if (birthMonth.length > 1 &&
        (int.parse(birthMonth) < 01 || int.parse(birthMonth) > 12)) {
      setState(() {
        birthMonthError = '';
      });
    } else if (birthMonth.length == 2) {
      birthMonthError = null;
      FocusScope.of(context).requestFocus(birthDayFocusNode);
    } else {
      setState(() {
        birthMonthError = null;
      });
    }
  }

  checkDay() {
    if (birthMonth == '02' && birthDay == '30') {
      birthDayError = '';
    } else if (birthDay == '31' &&
        (birthMonth == '02' ||
            birthMonth == '04' ||
            birthMonth == '06' ||
            birthMonth == '08' ||
            birthMonth == '09' ||
            birthMonth == '11')) {
      birthDayError = '';
    } else if (birthDay.length > 1 &&
        (int.parse(birthDay) < 1 || int.parse(birthDay) > 31)) {
      setState(() {
        birthDayError = '';
      });
    } else {
      birthDayError = null;
    }
  }

  checkDate() {
    if (birthMonth == '02' && birthDay == '30') {
      birthDayError = '';
    } else if (birthDay == '31' &&
        (birthMonth == '02' ||
            birthMonth == '04' ||
            birthMonth == '06' ||
            birthMonth == '08' ||
            birthMonth == '09' ||
            birthMonth == '11')) {
      birthDayError = '';
    } else {
      birthDayError = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 16,
              ),
              //  이름
              TextInputWidget(
                title: "이름",
                hintText: '실명을 입력해주세요',
                keyboardType: TextInputType.name,
                errorText: nameError,
                textInputAction: TextInputAction.next,
                focusNode: nameFocusNode,
                onChanged: (value) {
                  name = value;
                  checkName();
                },
              ),
              const SizedBox(
                height: 24,
              ),
              // 생년월일
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '생년월일',
                    style: getTsBody14Sb(context).copyWith(
                      color: kColorContentWeak,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Focus(
                            onFocusChange: (value) {
                              if (!value && birthYear.length != 4) {
                                setState(() {
                                  birthYearError = '';
                                });
                              }
                            },
                            child: CustomTextFormField(
                              textAlign: TextAlign.center,
                              maxLength: 4,
                              errorText: birthYearError,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              hintText: 'YYYY',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                setState(() {
                                  birthYear = value;
                                });
                                checkYear();
                              },
                            )),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Focus(
                                  onFocusChange: (value) {
                                    if (!value &&
                                        birthMonth.isNotEmpty &&
                                        birthMonth.length != 2) {
                                      setState(() {
                                        birthMonthError = '';
                                      });
                                    }
                                  },
                                  child: CustomTextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    hintText: 'MM',
                                    readOnly: birthYear.isEmpty ||
                                        birthYearError != null,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    errorText: birthMonthError,
                                    focusNode: birthMonthFocusNode,
                                    onChanged: (value) {
                                      setState(() {
                                        birthMonth = value;
                                      });
                                      checkMonth();
                                      checkDate();
                                    },
                                  )),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Focus(
                                  onFocusChange: (value) {
                                    if (!value &&
                                        birthDay.isNotEmpty &&
                                        birthDay.length != 2) {
                                      setState(() {
                                        birthDayError = '';
                                      });
                                    }
                                  },
                                  child: CustomTextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    hintText: 'DD',
                                    readOnly: birthMonth.isEmpty ||
                                        birthMonthError != null,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    errorText: birthDayError,
                                    focusNode: birthDayFocusNode,
                                    onChanged: (value) {
                                      setState(() {
                                        birthDay = value;
                                      });
                                      checkDay();
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '성별',
                    style: getTsBody14Sb(context).copyWith(
                      color: kColorContentWeak,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RadioWidget(
                      leftText: '여성',
                      rightText: '남성',
                      value: selectGender,
                      onTapLeft: () {
                        setState(() {
                          selectGender = RadioWidgetValueType.left;
                          isValidGender = true;
                        });
                      },
                      onTapRight: () {
                        setState(() {
                          selectGender = RadioWidgetValueType.right;
                          isValidGender = true;
                        });
                      })
                ],
              )
            ])),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const SingleNationalFlagScreen(),
                //     ));
                context.pushNamed(
                  SingleNationalFlagScreen.routeName,
                  extra: widget.signUpModel.copyWith(
                    name: name,
                    birth: '2023-09-23',
                    gender: selectGender == RadioWidgetValueType.left
                        ? 'female'
                        : 'male',
                  ),
                );
              },
              child: FullBleedButtonWidget(
                text: '다음',
                isEnable: isValidName &&
                    birthYear.isNotEmpty &&
                    birthYearError == null &&
                    birthMonth.isNotEmpty &&
                    birthMonthError == null &&
                    birthDay.isNotEmpty &&
                    birthDayError == null &&
                    isValidGender,
              ),
            ),
          )
        ],
      )),
    );
  }
}
