import 'package:biskit_app/common/components/filled_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:biskit_app/common/components/custom_text_form_field.dart';
import 'package:biskit_app/common/components/radio_widget.dart';
import 'package:biskit_app/common/components/text_input_widget.dart';
import 'package:biskit_app/common/const/colors.dart';
import 'package:biskit_app/common/const/fonts.dart';
import 'package:biskit_app/common/layout/default_layout.dart';
import 'package:biskit_app/common/view/single_national_flag_screen.dart';
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
  Color yearBorderColor = kColorBorderDefalut;
  Color monthBorderColor = kColorBorderDefalut;
  Color dayBorderColor = kColorBorderDefalut;
  late FocusNode birthYearFocusNode;
  late FocusNode birthMonthFocusNode;
  late FocusNode birthDayFocusNode;
  late FocusNode nameFocusNode;
  RadioWidgetValueType selectGender = RadioWidgetValueType.none;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    birthYearFocusNode = FocusNode();
    birthMonthFocusNode = FocusNode();
    birthDayFocusNode = FocusNode();
    nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    birthYearFocusNode.dispose();
    birthMonthFocusNode.dispose();
    birthDayFocusNode.dispose();
  }

  bool isValidNameType(String name) {
    RegExp koreanEnglishRegExp =
        RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+(\s[a-zA-Zㄱ-ㅎ가-힣]+)*$');
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
        yearBorderColor = kColorBorderError;
      });
    } else if (birthYear.length == 4) {
      setState(() {
        birthYearError = null;
        FocusScope.of(context).requestFocus(birthMonthFocusNode);
        yearBorderColor = kColorBorderDefalut;
      });
    } else {
      setState(() {
        birthYearError = null;
        yearBorderColor = kColorBorderStronger;
      });
    }
  }

  checkMonth() {
    if (birthMonth.length > 1 &&
        (int.parse(birthMonth) < 01 || int.parse(birthMonth) > 12)) {
      setState(() {
        birthMonthError = '';
        monthBorderColor = kColorBorderError;
      });
    } else if (birthMonth.length == 2) {
      setState(() {
        birthMonthError = null;
        monthBorderColor = kColorBorderDefalut;
        FocusScope.of(context).requestFocus(birthDayFocusNode);
      });
    } else {
      setState(() {
        birthMonthError = null;
        monthBorderColor = kColorBorderDefalut;
      });
    }
  }

  checkDay() {
    if (birthMonth == '02' && birthDay == '30') {
      setState(() {
        birthDayError = '';
        dayBorderColor = kColorBorderError;
      });
    } else if (birthDay == '31' &&
        (birthMonth == '02' ||
            birthMonth == '04' ||
            birthMonth == '06' ||
            birthMonth == '08' ||
            birthMonth == '09' ||
            birthMonth == '11')) {
      setState(() {
        birthDayError = '';
        dayBorderColor = kColorBorderError;
      });
    } else if (birthDay.length > 1 &&
        (int.parse(birthDay) < 1 || int.parse(birthDay) > 31)) {
      setState(() {
        birthDayError = '';
        dayBorderColor = kColorBorderError;
      });
    } else {
      setState(() {
        birthDayError = null;
        dayBorderColor = kColorBorderDefalut;
      });
    }
  }

  checkDate() {
    if (birthMonth == '02' && birthDay == '30') {
      birthDayError = '';
      dayBorderColor = kColorBorderError;
    } else if (birthDay == '31' &&
        (birthMonth == '02' ||
            birthMonth == '04' ||
            birthMonth == '06' ||
            birthMonth == '08' ||
            birthMonth == '09' ||
            birthMonth == '11')) {
      birthDayError = '';
      dayBorderColor = kColorBorderError;
    } else {
      birthDayError = null;
      dayBorderColor = kColorBorderDefalut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      resizeToAvoidBottomInset: false,
      title: '',
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(
              height: 16,
            ),
            //  이름
            TextInputWidget(
              title: "이름",
              hintText: '실명을 입력해주세요',
              keyboardType: TextInputType.name,
              errorText: nameError,
              textInputAction: TextInputAction.go,
              focusNode: nameFocusNode,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(birthYearFocusNode);
              },
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
                              yearBorderColor = kColorBorderError;
                            });
                          }
                        },
                        child: CustomTextFormField(
                          textAlign: TextAlign.center,
                          maxLength: 4,
                          borderColor: yearBorderColor,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          hintText: 'YYYY',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          focusNode: birthYearFocusNode,
                          onChanged: (value) {
                            setState(() {
                              birthYear = value;
                            });
                            checkYear();
                          },
                        ),
                      ),
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
                                      monthBorderColor = kColorBorderError;
                                    });
                                  }
                                },
                                child: CustomTextFormField(
                                  textAlign: TextAlign.center,
                                  maxLength: 2,
                                  borderColor: monthBorderColor,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'MM',
                                  readOnly: birthYear.isEmpty ||
                                      birthYearError != null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                      dayBorderColor = kColorBorderError;
                                    });
                                  }
                                },
                                child: CustomTextFormField(
                                  textAlign: TextAlign.center,
                                  maxLength: 2,
                                  borderColor: dayBorderColor,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'DD',
                                  readOnly: birthMonth.isEmpty ||
                                      birthMonthError != null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  focusNode: birthDayFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      birthDay = value;
                                    });
                                    checkDay();
                                    if (birthDay.length == 2) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    radioBtnGap: 8,
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
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  SingleNationalFlagScreen.routeName,
                  extra: widget.signUpModel.copyWith(
                    name: name,
                    birth: '$birthYear-$birthMonth-$birthDay',
                    gender: selectGender == RadioWidgetValueType.left
                        ? 'female'
                        : 'male',
                  ),
                );
              },
              child: FilledButtonWidget(
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
            const SizedBox(
              height: 34,
            ),
          ]),
        ),
      ),
    );
  }
}
